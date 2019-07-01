//
////Created by Lihux: malloc的真实实现，源自：
//
////https://repo.or.cz/w/glibc.git/blob/HEAD:/malloc/malloc.c
//
//1 /* Malloc implementation for multiple threads without lock contention.
//   2    Copyright (C) 1996-2019 Free Software Foundation, Inc.
//   3    This file is part of the GNU C Library.
//   4    Contributed by Wolfram Gloger <wg@malloc.de>
//   5    and Doug Lea <dl@cs.oswego.edu>, 2001.
//   6
//   7    The GNU C Library is free software; you can redistribute it and/or
//   8    modify it under the terms of the GNU Lesser General Public License as
//   9    published by the Free Software Foundation; either version 2.1 of the
//   10    License, or (at your option) any later version.
//   11
//   12    The GNU C Library is distributed in the hope that it will be useful,
//   13    but WITHOUT ANY WARRANTY; without even the implied warranty of
//   14    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//   15    Lesser General Public License for more details.
//   16
//   17    You should have received a copy of the GNU Lesser General Public
//   18    License along with the GNU C Library; see the file COPYING.LIB.  If
//   19    not, see <http://www.gnu.org/licenses/>.  */
//20
//21 /*
//    22   This is a version (aka ptmalloc2) of malloc/free/realloc written by
//    23   Doug Lea and adapted to multiple threads/arenas by Wolfram Gloger.
//    24
//    25   There have been substantial changes made after the integration into
//    26   glibc in all parts of the code.  Do not look for much commonality
//    27   with the ptmalloc2 version.
//    28
//    29 * Version ptmalloc2-20011215
//    30   based on:
//    31   VERSION 2.7.0 Sun Mar 11 14:14:06 2001  Doug Lea  (dl at gee)
//    32
//    33 * Quickstart
//    34
//    35   In order to compile this implementation, a Makefile is provided with
//    36   the ptmalloc2 distribution, which has pre-defined targets for some
//    37   popular systems (e.g. "make posix" for Posix threads).  All that is
//    38   typically required with regard to compiler flags is the selection of
//    39   the thread package via defining one out of USE_PTHREADS, USE_THR or
//    40   USE_SPROC.  Check the thread-m.h file for what effects this has.
//    41   Many/most systems will additionally require USE_TSD_DATA_HACK to be
//    42   defined, so this is the default for "make posix".
//    43
//    44 * Why use this malloc?
//    45
//    46   This is not the fastest, most space-conserving, most portable, or
//    47   most tunable malloc ever written. However it is among the fastest
//    48   while also being among the most space-conserving, portable and tunable.
//    49   Consistent balance across these factors results in a good general-purpose
//    50   allocator for malloc-intensive programs.
//    51
//    52   The main properties of the algorithms are:
//    53   * For large (>= 512 bytes) requests, it is a pure best-fit allocator,
//    54     with ties normally decided via FIFO (i.e. least recently used).
//    55   * For small (<= 64 bytes by default) requests, it is a caching
//    56     allocator, that maintains pools of quickly recycled chunks.
//    57   * In between, and for combinations of large and small requests, it does
//    58     the best it can trying to meet both goals at once.
//    59   * For very large requests (>= 128KB by default), it relies on system
//    60     memory mapping facilities, if supported.
//    61
//    62   For a longer but slightly out of date high-level description, see
//    63      http://gee.cs.oswego.edu/dl/html/malloc.html
//    64
//    65   You may already by default be using a C library containing a malloc
//    66   that is  based on some version of this malloc (for example in
//    67   linux). You might still want to use the one in this file in order to
//    68   customize settings or to avoid overheads associated with library
//    69   versions.
//    70
//    71 * Contents, described in more detail in "description of public routines" below.
//    72
//    73   Standard (ANSI/SVID/...)  functions:
//    74     malloc(size_t n);
//    75     calloc(size_t n_elements, size_t element_size);
//    76     free(void* p);
//    77     realloc(void* p, size_t n);
//    78     memalign(size_t alignment, size_t n);
//    79     valloc(size_t n);
//    80     mallinfo()
//    81     mallopt(int parameter_number, int parameter_value)
//    82
//    83   Additional functions:
//    84     independent_calloc(size_t n_elements, size_t size, void* chunks[]);
//    85     independent_comalloc(size_t n_elements, size_t sizes[], void* chunks[]);
//    86     pvalloc(size_t n);
//    87     malloc_trim(size_t pad);
//    88     malloc_usable_size(void* p);
//    89     malloc_stats();
//    90
//    91 * Vital statistics:
//    92
//    93   Supported pointer representation:       4 or 8 bytes
//    94   Supported size_t  representation:       4 or 8 bytes
//    95        Note that size_t is allowed to be 4 bytes even if pointers are 8.
//    96        You can adjust this by defining INTERNAL_SIZE_T
//    97
//    98   Alignment:                              2 * sizeof(size_t) (default)
//    99        (i.e., 8 byte alignment with 4byte size_t). This suffices for
//    100        nearly all current machines and C compilers. However, you can
//    101        define MALLOC_ALIGNMENT to be wider than this if necessary.
//    102
//    103   Minimum overhead per allocated chunk:   4 or 8 bytes
//    104        Each malloced chunk has a hidden word of overhead holding size
//    105        and status information.
//    106
//    107   Minimum allocated size: 4-byte ptrs:  16 bytes    (including 4 overhead)
//    108                           8-byte ptrs:  24/32 bytes (including, 4/8 overhead)
//    109
//    110        When a chunk is freed, 12 (for 4byte ptrs) or 20 (for 8 byte
//    111        ptrs but 4 byte size) or 24 (for 8/8) additional bytes are
//    112        needed; 4 (8) for a trailing size field and 8 (16) bytes for
//    113        free list pointers. Thus, the minimum allocatable size is
//    114        16/24/32 bytes.
//    115
//    116        Even a request for zero bytes (i.e., malloc(0)) returns a
//    117        pointer to something of the minimum allocatable size.
//    118
//    119        The maximum overhead wastage (i.e., number of extra bytes
//    120        allocated than were requested in malloc) is less than or equal
//    121        to the minimum size, except for requests >= mmap_threshold that
//    122        are serviced via mmap(), where the worst case wastage is 2 *
//    123        sizeof(size_t) bytes plus the remainder from a system page (the
//    124        minimal mmap unit); typically 4096 or 8192 bytes.
//    125
//    126   Maximum allocated size:  4-byte size_t: 2^32 minus about two pages
//    127                            8-byte size_t: 2^64 minus about two pages
//    128
//    129        It is assumed that (possibly signed) size_t values suffice to
//    130        represent chunk sizes. `Possibly signed' is due to the fact
//    131        that `size_t' may be defined on a system as either a signed or
//    132        an unsigned type. The ISO C standard says that it must be
//    133        unsigned, but a few systems are known not to adhere to this.
//    134        Additionally, even when size_t is unsigned, sbrk (which is by
//    135        default used to obtain memory from system) accepts signed
//    136        arguments, and may not be able to handle size_t-wide arguments
//    137        with negative sign bit.  Generally, values that would
//    138        appear as negative after accounting for overhead and alignment
//    139        are supported only via mmap(), which does not have this
//    140        limitation.
//    141
//    142        Requests for sizes outside the allowed range will perform an optional
//    143        failure action and then return null. (Requests may also
//    144        also fail because a system is out of memory.)
//    145
//    146   Thread-safety: thread-safe
//    147
//    148   Compliance: I believe it is compliant with the 1997 Single Unix Specification
//    149        Also SVID/XPG, ANSI C, and probably others as well.
//    150
//    151 * Synopsis of compile-time options:
//    152
//    153     People have reported using previous versions of this malloc on all
//    154     versions of Unix, sometimes by tweaking some of the defines
//    155     below. It has been tested most extensively on Solaris and Linux.
//    156     People also report using it in stand-alone embedded systems.
//    157
//    158     The implementation is in straight, hand-tuned ANSI C.  It is not
//    159     at all modular. (Sorry!)  It uses a lot of macros.  To be at all
//    160     usable, this code should be compiled using an optimizing compiler
//    161     (for example gcc -O3) that can simplify expressions and control
//    162     paths. (FAQ: some macros import variables as arguments rather than
//    163     declare locals because people reported that some debuggers
//    164     otherwise get confused.)
//    165
//    166     OPTION                     DEFAULT VALUE
//    167
//    168     Compilation Environment options:
//    169
//    170     HAVE_MREMAP                0
//    171
//    172     Changing default word sizes:
//    173
//    174     INTERNAL_SIZE_T            size_t
//    175
//    176     Configuration and functionality options:
//    177
//    178     USE_PUBLIC_MALLOC_WRAPPERS NOT defined
//    179     USE_MALLOC_LOCK            NOT defined
//    180     MALLOC_DEBUG               NOT defined
//    181     REALLOC_ZERO_BYTES_FREES   1
//    182     TRIM_FASTBINS              0
//    183
//    184     Options for customizing MORECORE:
//    185
//    186     MORECORE                   sbrk
//    187     MORECORE_FAILURE           -1
//    188     MORECORE_CONTIGUOUS        1
//    189     MORECORE_CANNOT_TRIM       NOT defined
//    190     MORECORE_CLEARS            1
//    191     MMAP_AS_MORECORE_SIZE      (1024 * 1024)
//    192
//    193     Tuning options that are also dynamically changeable via mallopt:
//    194
//    195     DEFAULT_MXFAST             64 (for 32bit), 128 (for 64bit)
//    196     DEFAULT_TRIM_THRESHOLD     128 * 1024
//    197     DEFAULT_TOP_PAD            0
//    198     DEFAULT_MMAP_THRESHOLD     128 * 1024
//    199     DEFAULT_MMAP_MAX           65536
//    200
//    201     There are several other #defined constants and macros that you
//    202     probably don't want to touch unless you are extending or adapting malloc.  */
//203
//204 /*
//     205   void* is the pointer type that malloc should say it returns
//     206 */
//207
//208 #ifndef void
//209 #define void      void
//210 #endif /*void*/
//211
//212 #include <stddef.h>   /* for size_t */
//213 #include <stdlib.h>   /* for getenv(), abort() */
//214 #include <unistd.h>   /* for __libc_enable_secure */
//215
//216 #include <atomic.h>
//217 #include <_itoa.h>
//218 #include <bits/wordsize.h>
//219 #include <sys/sysinfo.h>
//220
//221 #include <ldsodefs.h>
//222
//223 #include <unistd.h>
//224 #include <stdio.h>    /* needed for malloc_stats */
//225 #include <errno.h>
//226 #include <assert.h>
//227
//228 #include <shlib-compat.h>
//229
//230 /* For uintptr_t.  */
//231 #include <stdint.h>
//232
//233 /* For va_arg, va_start, va_end.  */
//234 #include <stdarg.h>
//235
//236 /* For MIN, MAX, powerof2.  */
//237 #include <sys/param.h>
//238
//239 /* For ALIGN_UP et. al.  */
//240 #include <libc-pointer-arith.h>
//241
//242 /* For DIAG_PUSH/POP_NEEDS_COMMENT et al.  */
//243 #include <libc-diag.h>
//244
//245 #include <malloc/malloc-internal.h>
//246
//247 /* For SINGLE_THREAD_P.  */
//248 #include <sysdep-cancel.h>
//249
//250 /*
//     251   Debugging:
//     252
//     253   Because freed chunks may be overwritten with bookkeeping fields, this
//     254   malloc will often die when freed memory is overwritten by user
//     255   programs.  This can be very effective (albeit in an annoying way)
//     256   in helping track down dangling pointers.
//     257
//     258   If you compile with -DMALLOC_DEBUG, a number of assertion checks are
//     259   enabled that will catch more memory errors. You probably won't be
//     260   able to make much sense of the actual assertion errors, but they
//     261   should help you locate incorrectly overwritten memory.  The checking
//     262   is fairly extensive, and will slow down execution
//     263   noticeably. Calling malloc_stats or mallinfo with MALLOC_DEBUG set
//     264   will attempt to check every non-mmapped allocated and free chunk in
//     265   the course of computing the summmaries. (By nature, mmapped regions
//     266   cannot be checked very much automatically.)
//     267
//     268   Setting MALLOC_DEBUG may also be helpful if you are trying to modify
//     269   this code. The assertions in the check routines spell out in more
//     270   detail the assumptions and invariants underlying the algorithms.
//     271
//     272   Setting MALLOC_DEBUG does NOT provide an automated mechanism for
//     273   checking that all accesses to malloced memory stay within their
//     274   bounds. However, there are several add-ons and adaptations of this
//     275   or other mallocs available that do this.
//     276 */
//277
//278 #ifndef MALLOC_DEBUG
//279 #define MALLOC_DEBUG 0
//280 #endif
//281
//282 #ifndef NDEBUG
//283 # define __assert_fail(assertion, file, line, function)                 \
//284          __malloc_assert(assertion, file, line, function)
//285
//286 extern const char *__progname;
//287
//288 static void
//289 __malloc_assert (const char *assertion, const char *file, unsigned int line,
//                     290                  const char *function)
//291 {
//    292   (void) __fxprintf (NULL, "%s%s%s:%u: %s%sAssertion `%s' failed.\n",
//                             293                      __progname, __progname[0] ? ": " : "",
//                             294                      file, line,
//                             295                      function ? function : "", function ? ": " : "",
//                             296                      assertion);
//    297   fflush (stderr);
//    298   abort ();
//    299 }
//300 #endif
//301
//302 #if USE_TCACHE
//303 /* We want 64 entries.  This is an arbitrary limit, which tunables can reduce.  */
//304 # define TCACHE_MAX_BINS                64
//305 # define MAX_TCACHE_SIZE        tidx2usize (TCACHE_MAX_BINS-1)
//306
//307 /* Only used to pre-fill the tunables.  */
//308 # define tidx2usize(idx)        (((size_t) idx) * MALLOC_ALIGNMENT + MINSIZE - SIZE_SZ)
//309
//310 /* When "x" is from chunksize().  */
//311 # define csize2tidx(x) (((x) - MINSIZE + MALLOC_ALIGNMENT - 1) / MALLOC_ALIGNMENT)
//312 /* When "x" is a user-provided size.  */
//313 # define usize2tidx(x) csize2tidx (request2size (x))
//314
//315 /* With rounding and alignment, the bins are...
//     316    idx 0   bytes 0..24 (64-bit) or 0..12 (32-bit)
//     317    idx 1   bytes 25..40 or 13..20
//     318    idx 2   bytes 41..56 or 21..28
//     319    etc.  */
//320
//321 /* This is another arbitrary limit, which tunables can change.  Each
//     322    tcache bin will hold at most this number of chunks.  */
//323 # define TCACHE_FILL_COUNT 7
//324
//325 /* Maximum chunks in tcache bins for tunables.  This value must fit the range
//     326    of tcache->counts[] entries, else they may overflow.  */
//327 # define MAX_TCACHE_COUNT UINT16_MAX
//328 #endif
//329
//330
//331 /*
//     332   REALLOC_ZERO_BYTES_FREES should be set if a call to
//     333   realloc with zero bytes should be the same as a call to free.
//     334   This is required by the C standard. Otherwise, since this malloc
//     335   returns a unique pointer for malloc(0), so does realloc(p, 0).
//     336 */
//337
//338 #ifndef REALLOC_ZERO_BYTES_FREES
//339 #define REALLOC_ZERO_BYTES_FREES 1
//340 #endif
//341
//342 /*
//     343   TRIM_FASTBINS controls whether free() of a very small chunk can
//     344   immediately lead to trimming. Setting to true (1) can reduce memory
//     345   footprint, but will almost always slow down programs that use a lot
//     346   of small chunks.
//     347
//     348   Define this only if you are willing to give up some speed to more
//     349   aggressively reduce system-level memory footprint when releasing
//     350   memory in programs that use many small chunks.  You can get
//     351   essentially the same effect by setting MXFAST to 0, but this can
//     352   lead to even greater slowdowns in programs using many small chunks.
//     353   TRIM_FASTBINS is an in-between compile-time option, that disables
//     354   only those chunks bordering topmost memory from being placed in
//     355   fastbins.
//     356 */
//357
//358 #ifndef TRIM_FASTBINS
//359 #define TRIM_FASTBINS  0
//360 #endif
//361
//362
//363 /* Definition for getting more memory from the OS.  */
//364 #define MORECORE         (*__morecore)
//365 #define MORECORE_FAILURE 0
//366 void * __default_morecore (ptrdiff_t);
//367 void *(*__morecore)(ptrdiff_t) = __default_morecore;
//368
//369
//370 #include <string.h>
//371
//372 /*
//     373   MORECORE-related declarations. By default, rely on sbrk
//     374 */
//375
//376
//377 /*
//     378   MORECORE is the name of the routine to call to obtain more memory
//     379   from the system.  See below for general guidance on writing
//     380   alternative MORECORE functions, as well as a version for WIN32 and a
//     381   sample version for pre-OSX macos.
//     382 */
//383
//384 #ifndef MORECORE
//385 #define MORECORE sbrk
//386 #endif
//387
//388 /*
//     389   MORECORE_FAILURE is the value returned upon failure of MORECORE
//     390   as well as mmap. Since it cannot be an otherwise valid memory address,
//     391   and must reflect values of standard sys calls, you probably ought not
//     392   try to redefine it.
//     393 */
//394
//395 #ifndef MORECORE_FAILURE
//396 #define MORECORE_FAILURE (-1)
//397 #endif
//398
//399 /*
//     400   If MORECORE_CONTIGUOUS is true, take advantage of fact that
//     401   consecutive calls to MORECORE with positive arguments always return
//     402   contiguous increasing addresses.  This is true of unix sbrk.  Even
//     403   if not defined, when regions happen to be contiguous, malloc will
//     404   permit allocations spanning regions obtained from different
//     405   calls. But defining this when applicable enables some stronger
//     406   consistency checks and space efficiencies.
//     407 */
//408
//409 #ifndef MORECORE_CONTIGUOUS
//410 #define MORECORE_CONTIGUOUS 1
//411 #endif
//412
//413 /*
//     414   Define MORECORE_CANNOT_TRIM if your version of MORECORE
//     415   cannot release space back to the system when given negative
//     416   arguments. This is generally necessary only if you are using
//     417   a hand-crafted MORECORE function that cannot handle negative arguments.
//     418 */
//419
//420 /* #define MORECORE_CANNOT_TRIM */
//421
//422 /*  MORECORE_CLEARS           (default 1)
//     423      The degree to which the routine mapped to MORECORE zeroes out
//     424      memory: never (0), only for newly allocated space (1) or always
//     425      (2).  The distinction between (1) and (2) is necessary because on
//     426      some systems, if the application first decrements and then
//     427      increments the break value, the contents of the reallocated space
//     428      are unspecified.
//     429  */
//430
//431 #ifndef MORECORE_CLEARS
//432 # define MORECORE_CLEARS 1
//433 #endif
//434
//435
//436 /*
//     437    MMAP_AS_MORECORE_SIZE is the minimum mmap size argument to use if
//     438    sbrk fails, and mmap is used as a backup.  The value must be a
//     439    multiple of page size.  This backup strategy generally applies only
//     440    when systems have "holes" in address space, so sbrk cannot perform
//     441    contiguous expansion, but there is still space available on system.
//     442    On systems for which this is known to be useful (i.e. most linux
//     443    kernels), this occurs only when programs allocate huge amounts of
//     444    memory.  Between this, and the fact that mmap regions tend to be
//     445    limited, the size should be large, to avoid too many mmap calls and
//     446    thus avoid running out of kernel resources.  */
//447
//448 #ifndef MMAP_AS_MORECORE_SIZE
//449 #define MMAP_AS_MORECORE_SIZE (1024 * 1024)
//450 #endif
//451
//452 /*
//     453   Define HAVE_MREMAP to make realloc() use mremap() to re-allocate
//     454   large blocks.
//     455 */
//456
//457 #ifndef HAVE_MREMAP
//458 #define HAVE_MREMAP 0
//459 #endif
//460
//461 /* We may need to support __malloc_initialize_hook for backwards
//     462    compatibility.  */
//463
//464 #if SHLIB_COMPAT (libc, GLIBC_2_0, GLIBC_2_24)
//465 # define HAVE_MALLOC_INIT_HOOK 1
//466 #else
//467 # define HAVE_MALLOC_INIT_HOOK 0
//468 #endif
//469
//470
//471 /*
//     472   This version of malloc supports the standard SVID/XPG mallinfo
//     473   routine that returns a struct containing usage properties and
//     474   statistics. It should work on any SVID/XPG compliant system that has
//     475   a /usr/include/malloc.h defining struct mallinfo. (If you'd like to
//     476   install such a thing yourself, cut out the preliminary declarations
//     477   as described above and below and save them in a malloc.h file. But
//     478   there's no compelling reason to bother to do this.)
//     479
//     480   The main declaration needed is the mallinfo struct that is returned
//     481   (by-copy) by mallinfo().  The SVID/XPG malloinfo struct contains a
//     482   bunch of fields that are not even meaningful in this version of
//     483   malloc.  These fields are are instead filled by mallinfo() with
//     484   other numbers that might be of interest.
//     485 */
//486
//487
//488 /* ---------- description of public routines ------------ */
//489
//490 /*
//     491   malloc(size_t n)
//     492   Returns a pointer to a newly allocated chunk of at least n bytes, or null
//     493   if no space is available. Additionally, on failure, errno is
//     494   set to ENOMEM on ANSI C systems.
//     495
//     496   If n is zero, malloc returns a minumum-sized chunk. (The minimum
//     497   size is 16 bytes on most 32bit systems, and 24 or 32 bytes on 64bit
//     498   systems.)  On most systems, size_t is an unsigned type, so calls
//     499   with negative arguments are interpreted as requests for huge amounts
//     500   of space, which will often fail. The maximum supported value of n
//     501   differs across systems, but is in all cases less than the maximum
//     502   representable value of a size_t.
//     503 */
//504 void*  __libc_malloc(size_t);
//505 libc_hidden_proto (__libc_malloc)
//506
//507 /*
//     508   free(void* p)
//     509   Releases the chunk of memory pointed to by p, that had been previously
//     510   allocated using malloc or a related routine such as realloc.
//     511   It has no effect if p is null. It can have arbitrary (i.e., bad!)
//     512   effects if p has already been freed.
//     513
//     514   Unless disabled (using mallopt), freeing very large spaces will
//     515   when possible, automatically trigger operations that give
//     516   back unused memory to the system, thus reducing program footprint.
//     517 */
//518 void     __libc_free(void*);
//519 libc_hidden_proto (__libc_free)
//520
//521 /*
//     522   calloc(size_t n_elements, size_t element_size);
//     523   Returns a pointer to n_elements * element_size bytes, with all locations
//     524   set to zero.
//     525 */
//526 void*  __libc_calloc(size_t, size_t);
//527
//528 /*
//     529   realloc(void* p, size_t n)
//     530   Returns a pointer to a chunk of size n that contains the same data
//     531   as does chunk p up to the minimum of (n, p's size) bytes, or null
//     532   if no space is available.
//     533
//     534   The returned pointer may or may not be the same as p. The algorithm
//     535   prefers extending p when possible, otherwise it employs the
//     536   equivalent of a malloc-copy-free sequence.
//     537
//     538   If p is null, realloc is equivalent to malloc.
//     539
//     540   If space is not available, realloc returns null, errno is set (if on
//     541   ANSI) and p is NOT freed.
//     542
//     543   if n is for fewer bytes than already held by p, the newly unused
//     544   space is lopped off and freed if possible.  Unless the #define
//     545   REALLOC_ZERO_BYTES_FREES is set, realloc with a size argument of
//     546   zero (re)allocates a minimum-sized chunk.
//     547
//     548   Large chunks that were internally obtained via mmap will always be
//     549   grown using malloc-copy-free sequences unless the system supports
//     550   MREMAP (currently only linux).
//     551
//     552   The old unix realloc convention of allowing the last-free'd chunk
//     553   to be used as an argument to realloc is not supported.
//     554 */
//555 void*  __libc_realloc(void*, size_t);
//556 libc_hidden_proto (__libc_realloc)
//557
//558 /*
//     559   memalign(size_t alignment, size_t n);
//     560   Returns a pointer to a newly allocated chunk of n bytes, aligned
//     561   in accord with the alignment argument.
//     562
//     563   The alignment argument should be a power of two. If the argument is
//     564   not a power of two, the nearest greater power is used.
//     565   8-byte alignment is guaranteed by normal malloc calls, so don't
//     566   bother calling memalign with an argument of 8 or less.
//     567
//     568   Overreliance on memalign is a sure way to fragment space.
//     569 */
//570 void*  __libc_memalign(size_t, size_t);
//571 libc_hidden_proto (__libc_memalign)
//572
//573 /*
//     574   valloc(size_t n);
//     575   Equivalent to memalign(pagesize, n), where pagesize is the page
//     576   size of the system. If the pagesize is unknown, 4096 is used.
//     577 */
//578 void*  __libc_valloc(size_t);
//579
//580
//581
//582 /*
//     583   mallopt(int parameter_number, int parameter_value)
//     584   Sets tunable parameters The format is to provide a
//     585   (parameter-number, parameter-value) pair.  mallopt then sets the
//     586   corresponding parameter to the argument value if it can (i.e., so
//     587   long as the value is meaningful), and returns 1 if successful else
//     588   0.  SVID/XPG/ANSI defines four standard param numbers for mallopt,
//     589   normally defined in malloc.h.  Only one of these (M_MXFAST) is used
//     590   in this malloc. The others (M_NLBLKS, M_GRAIN, M_KEEP) don't apply,
//     591   so setting them has no effect. But this malloc also supports four
//     592   other options in mallopt. See below for details.  Briefly, supported
//     593   parameters are as follows (listed defaults are for "typical"
//     594   configurations).
//     595
//     596   Symbol            param #   default    allowed param values
//     597   M_MXFAST          1         64         0-80  (0 disables fastbins)
//     598   M_TRIM_THRESHOLD -1         128*1024   any   (-1U disables trimming)
//     599   M_TOP_PAD        -2         0          any
//     600   M_MMAP_THRESHOLD -3         128*1024   any   (or 0 if no MMAP support)
//     601   M_MMAP_MAX       -4         65536      any   (0 disables use of mmap)
//     602 */
//603 int      __libc_mallopt(int, int);
//604 libc_hidden_proto (__libc_mallopt)
//605
//606
//607 /*
//     608   mallinfo()
//     609   Returns (by copy) a struct containing various summary statistics:
//     610
//     611   arena:     current total non-mmapped bytes allocated from system
//     612   ordblks:   the number of free chunks
//     613   smblks:    the number of fastbin blocks (i.e., small chunks that
//     614                have been freed but not use resused or consolidated)
//     615   hblks:     current number of mmapped regions
//     616   hblkhd:    total bytes held in mmapped regions
//     617   usmblks:   always 0
//     618   fsmblks:   total bytes held in fastbin blocks
//     619   uordblks:  current total allocated space (normal or mmapped)
//     620   fordblks:  total free space
//     621   keepcost:  the maximum number of bytes that could ideally be released
//     622                back to system via malloc_trim. ("ideally" means that
//     623                it ignores page restrictions etc.)
//     624
//     625   Because these fields are ints, but internal bookkeeping may
//     626   be kept as longs, the reported values may wrap around zero and
//     627   thus be inaccurate.
//     628 */
//629 struct mallinfo __libc_mallinfo(void);
//630
//631
//632 /*
//     633   pvalloc(size_t n);
//     634   Equivalent to valloc(minimum-page-that-holds(n)), that is,
//     635   round up n to nearest pagesize.
//     636  */
//637 void*  __libc_pvalloc(size_t);
//638
//639 /*
//     640   malloc_trim(size_t pad);
//     641
//     642   If possible, gives memory back to the system (via negative
//     643   arguments to sbrk) if there is unused memory at the `high' end of
//     644   the malloc pool. You can call this after freeing large blocks of
//     645   memory to potentially reduce the system-level memory requirements
//     646   of a program. However, it cannot guarantee to reduce memory. Under
//     647   some allocation patterns, some large free blocks of memory will be
//     648   locked between two used chunks, so they cannot be given back to
//     649   the system.
//     650
//     651   The `pad' argument to malloc_trim represents the amount of free
//     652   trailing space to leave untrimmed. If this argument is zero,
//     653   only the minimum amount of memory to maintain internal data
//     654   structures will be left (one page or less). Non-zero arguments
//     655   can be supplied to maintain enough trailing space to service
//     656   future expected allocations without having to re-obtain memory
//     657   from the system.
//     658
//     659   Malloc_trim returns 1 if it actually released any memory, else 0.
//     660   On systems that do not support "negative sbrks", it will always
//     661   return 0.
//     662 */
//663 int      __malloc_trim(size_t);
//664
//665 /*
//     666   malloc_usable_size(void* p);
//     667
//     668   Returns the number of bytes you can actually use in
//     669   an allocated chunk, which may be more than you requested (although
//     670   often not) due to alignment and minimum size constraints.
//     671   You can use this many bytes without worrying about
//     672   overwriting other allocated objects. This is not a particularly great
//     673   programming practice. malloc_usable_size can be more useful in
//     674   debugging and assertions, for example:
//     675
//     676   p = malloc(n);
//     677   assert(malloc_usable_size(p) >= 256);
//     678
//     679 */
//680 size_t   __malloc_usable_size(void*);
//681
//682 /*
//     683   malloc_stats();
//     684   Prints on stderr the amount of space obtained from the system (both
//     685   via sbrk and mmap), the maximum amount (which may be more than
//     686   current if malloc_trim and/or munmap got called), and the current
//     687   number of bytes allocated via malloc (or realloc, etc) but not yet
//     688   freed. Note that this is the number of bytes allocated, not the
//     689   number requested. It will be larger than the number requested
//     690   because of alignment and bookkeeping overhead. Because it includes
//     691   alignment wastage as being in use, this figure may be greater than
//     692   zero even when no user-level chunks are allocated.
//     693
//     694   The reported current and maximum system memory can be inaccurate if
//     695   a program makes other calls to system memory allocation functions
//     696   (normally sbrk) outside of malloc.
//     697
//     698   malloc_stats prints only the most commonly interesting statistics.
//     699   More information can be obtained by calling mallinfo.
//     700
//     701 */
//702 void     __malloc_stats(void);
//703
//704 /*
//     705   posix_memalign(void **memptr, size_t alignment, size_t size);
//     706
//     707   POSIX wrapper like memalign(), checking for validity of size.
//     708 */
//709 int      __posix_memalign(void **, size_t, size_t);
//710
//711 /* mallopt tuning options */
//712
//713 /*
//     714   M_MXFAST is the maximum request size used for "fastbins", special bins
//     715   that hold returned chunks without consolidating their spaces. This
//     716   enables future requests for chunks of the same size to be handled
//     717   very quickly, but can increase fragmentation, and thus increase the
//     718   overall memory footprint of a program.
//     719
//     720   This malloc manages fastbins very conservatively yet still
//     721   efficiently, so fragmentation is rarely a problem for values less
//     722   than or equal to the default.  The maximum supported value of MXFAST
//     723   is 80. You wouldn't want it any higher than this anyway.  Fastbins
//     724   are designed especially for use with many small structs, objects or
//     725   strings -- the default handles structs/objects/arrays with sizes up
//     726   to 8 4byte fields, or small strings representing words, tokens,
//     727   etc. Using fastbins for larger objects normally worsens
//     728   fragmentation without improving speed.
//     729
//     730   M_MXFAST is set in REQUEST size units. It is internally used in
//     731   chunksize units, which adds padding and alignment.  You can reduce
//     732   M_MXFAST to 0 to disable all use of fastbins.  This causes the malloc
//     733   algorithm to be a closer approximation of fifo-best-fit in all cases,
//     734   not just for larger requests, but will generally cause it to be
//     735   slower.
//     736 */
//737
//738
//739 /* M_MXFAST is a standard SVID/XPG tuning option, usually listed in malloc.h */
//740 #ifndef M_MXFAST
//741 #define M_MXFAST            1
//742 #endif
//743
//744 #ifndef DEFAULT_MXFAST
//745 #define DEFAULT_MXFAST     (64 * SIZE_SZ / 4)
//746 #endif
//747
//748
//749 /*
//     750   M_TRIM_THRESHOLD is the maximum amount of unused top-most memory
//     751   to keep before releasing via malloc_trim in free().
//     752
//     753   Automatic trimming is mainly useful in long-lived programs.
//     754   Because trimming via sbrk can be slow on some systems, and can
//     755   sometimes be wasteful (in cases where programs immediately
//     756   afterward allocate more large chunks) the value should be high
//     757   enough so that your overall system performance would improve by
//     758   releasing this much memory.
//     759
//     760   The trim threshold and the mmap control parameters (see below)
//     761   can be traded off with one another. Trimming and mmapping are
//     762   two different ways of releasing unused memory back to the
//     763   system. Between these two, it is often possible to keep
//     764   system-level demands of a long-lived program down to a bare
//     765   minimum. For example, in one test suite of sessions measuring
//     766   the XF86 X server on Linux, using a trim threshold of 128K and a
//     767   mmap threshold of 192K led to near-minimal long term resource
//     768   consumption.
//     769
//     770   If you are using this malloc in a long-lived program, it should
//     771   pay to experiment with these values.  As a rough guide, you
//     772   might set to a value close to the average size of a process
//     773   (program) running on your system.  Releasing this much memory
//     774   would allow such a process to run in memory.  Generally, it's
//     775   worth it to tune for trimming rather tham memory mapping when a
//     776   program undergoes phases where several large chunks are
//     777   allocated and released in ways that can reuse each other's
//     778   storage, perhaps mixed with phases where there are no such
//     779   chunks at all.  And in well-behaved long-lived programs,
//     780   controlling release of large blocks via trimming versus mapping
//     781   is usually faster.
//     782
//     783   However, in most programs, these parameters serve mainly as
//     784   protection against the system-level effects of carrying around
//     785   massive amounts of unneeded memory. Since frequent calls to
//     786   sbrk, mmap, and munmap otherwise degrade performance, the default
//     787   parameters are set to relatively high values that serve only as
//     788   safeguards.
//     789
//     790   The trim value It must be greater than page size to have any useful
//     791   effect.  To disable trimming completely, you can set to
//     792   (unsigned long)(-1)
//     793
//     794   Trim settings interact with fastbin (MXFAST) settings: Unless
//     795   TRIM_FASTBINS is defined, automatic trimming never takes place upon
//     796   freeing a chunk with size less than or equal to MXFAST. Trimming is
//     797   instead delayed until subsequent freeing of larger chunks. However,
//     798   you can still force an attempted trim by calling malloc_trim.
//     799
//     800   Also, trimming is not generally possible in cases where
//     801   the main arena is obtained via mmap.
//     802
//     803   Note that the trick some people use of mallocing a huge space and
//     804   then freeing it at program startup, in an attempt to reserve system
//     805   memory, doesn't have the intended effect under automatic trimming,
//     806   since that memory will immediately be returned to the system.
//     807 */
//808
//809 #define M_TRIM_THRESHOLD       -1
//810
//811 #ifndef DEFAULT_TRIM_THRESHOLD
//812 #define DEFAULT_TRIM_THRESHOLD (128 * 1024)
//813 #endif
//814
//815 /*
//     816   M_TOP_PAD is the amount of extra `padding' space to allocate or
//     817   retain whenever sbrk is called. It is used in two ways internally:
//     818
//     819   * When sbrk is called to extend the top of the arena to satisfy
//     820   a new malloc request, this much padding is added to the sbrk
//     821   request.
//     822
//     823   * When malloc_trim is called automatically from free(),
//     824   it is used as the `pad' argument.
//     825
//     826   In both cases, the actual amount of padding is rounded
//     827   so that the end of the arena is always a system page boundary.
//     828
//     829   The main reason for using padding is to avoid calling sbrk so
//     830   often. Having even a small pad greatly reduces the likelihood
//     831   that nearly every malloc request during program start-up (or
//     832   after trimming) will invoke sbrk, which needlessly wastes
//     833   time.
//     834
//     835   Automatic rounding-up to page-size units is normally sufficient
//     836   to avoid measurable overhead, so the default is 0.  However, in
//     837   systems where sbrk is relatively slow, it can pay to increase
//     838   this value, at the expense of carrying around more memory than
//     839   the program needs.
//     840 */
//841
//842 #define M_TOP_PAD              -2
//843
//844 #ifndef DEFAULT_TOP_PAD
//845 #define DEFAULT_TOP_PAD        (0)
//846 #endif
//847
//848 /*
//     849   MMAP_THRESHOLD_MAX and _MIN are the bounds on the dynamically
//     850   adjusted MMAP_THRESHOLD.
//     851 */
//852
//853 #ifndef DEFAULT_MMAP_THRESHOLD_MIN
//854 #define DEFAULT_MMAP_THRESHOLD_MIN (128 * 1024)
//855 #endif
//856
//857 #ifndef DEFAULT_MMAP_THRESHOLD_MAX
//858   /* For 32-bit platforms we cannot increase the maximum mmap
//       859      threshold much because it is also the minimum value for the
//       860      maximum heap size and its alignment.  Going above 512k (i.e., 1M
//       861      for new heaps) wastes too much address space.  */
//862 # if __WORDSIZE == 32
//863 #  define DEFAULT_MMAP_THRESHOLD_MAX (512 * 1024)
//864 # else
//865 #  define DEFAULT_MMAP_THRESHOLD_MAX (4 * 1024 * 1024 * sizeof(long))
//866 # endif
//867 #endif
//868
//869 /*
//     870   M_MMAP_THRESHOLD is the request size threshold for using mmap()
//     871   to service a request. Requests of at least this size that cannot
//     872   be allocated using already-existing space will be serviced via mmap.
//     873   (If enough normal freed space already exists it is used instead.)
//     874
//     875   Using mmap segregates relatively large chunks of memory so that
//     876   they can be individually obtained and released from the host
//     877   system. A request serviced through mmap is never reused by any
//     878   other request (at least not directly; the system may just so
//     879   happen to remap successive requests to the same locations).
//     880
//     881   Segregating space in this way has the benefits that:
//     882
//     883    1. Mmapped space can ALWAYS be individually released back
//     884       to the system, which helps keep the system level memory
//     885       demands of a long-lived program low.
//     886    2. Mapped memory can never become `locked' between
//     887       other chunks, as can happen with normally allocated chunks, which
//     888       means that even trimming via malloc_trim would not release them.
//     889    3. On some systems with "holes" in address spaces, mmap can obtain
//     890       memory that sbrk cannot.
//     891
//     892   However, it has the disadvantages that:
//     893
//     894    1. The space cannot be reclaimed, consolidated, and then
//     895       used to service later requests, as happens with normal chunks.
//     896    2. It can lead to more wastage because of mmap page alignment
//     897       requirements
//     898    3. It causes malloc performance to be more dependent on host
//     899       system memory management support routines which may vary in
//     900       implementation quality and may impose arbitrary
//     901       limitations. Generally, servicing a request via normal
//     902       malloc steps is faster than going through a system's mmap.
//     903
//     904   The advantages of mmap nearly always outweigh disadvantages for
//     905   "large" chunks, but the value of "large" varies across systems.  The
//     906   default is an empirically derived value that works well in most
//     907   systems.
//     908
//     909
//     910   Update in 2006:
//     911   The above was written in 2001. Since then the world has changed a lot.
//     912   Memory got bigger. Applications got bigger. The virtual address space
//     913   layout in 32 bit linux changed.
//     914
//     915   In the new situation, brk() and mmap space is shared and there are no
//     916   artificial limits on brk size imposed by the kernel. What is more,
//     917   applications have started using transient allocations larger than the
//     918   128Kb as was imagined in 2001.
//     919
//     920   The price for mmap is also high now; each time glibc mmaps from the
//     921   kernel, the kernel is forced to zero out the memory it gives to the
//     922   application. Zeroing memory is expensive and eats a lot of cache and
//     923   memory bandwidth. This has nothing to do with the efficiency of the
//     924   virtual memory system, by doing mmap the kernel just has no choice but
//     925   to zero.
//     926
//     927   In 2001, the kernel had a maximum size for brk() which was about 800
//     928   megabytes on 32 bit x86, at that point brk() would hit the first
//     929   mmaped shared libaries and couldn't expand anymore. With current 2.6
//     930   kernels, the VA space layout is different and brk() and mmap
//     931   both can span the entire heap at will.
//     932
//     933   Rather than using a static threshold for the brk/mmap tradeoff,
//     934   we are now using a simple dynamic one. The goal is still to avoid
//     935   fragmentation. The old goals we kept are
//     936   1) try to get the long lived large allocations to use mmap()
//     937   2) really large allocations should always use mmap()
//     938   and we're adding now:
//     939   3) transient allocations should use brk() to avoid forcing the kernel
//     940      having to zero memory over and over again
//     941
//     942   The implementation works with a sliding threshold, which is by default
//     943   limited to go between 128Kb and 32Mb (64Mb for 64 bitmachines) and starts
//     944   out at 128Kb as per the 2001 default.
//     945
//     946   This allows us to satisfy requirement 1) under the assumption that long
//     947   lived allocations are made early in the process' lifespan, before it has
//     948   started doing dynamic allocations of the same size (which will
//     949   increase the threshold).
//     950
//     951   The upperbound on the threshold satisfies requirement 2)
//     952
//     953   The threshold goes up in value when the application frees memory that was
//     954   allocated with the mmap allocator. The idea is that once the application
//     955   starts freeing memory of a certain size, it's highly probable that this is
//     956   a size the application uses for transient allocations. This estimator
//     957   is there to satisfy the new third requirement.
//     958
//     959 */
//960
//961 #define M_MMAP_THRESHOLD      -3
//962
//963 #ifndef DEFAULT_MMAP_THRESHOLD
//964 #define DEFAULT_MMAP_THRESHOLD DEFAULT_MMAP_THRESHOLD_MIN
//965 #endif
//966
//967 /*
//     968   M_MMAP_MAX is the maximum number of requests to simultaneously
//     969   service using mmap. This parameter exists because
//     970   some systems have a limited number of internal tables for
//     971   use by mmap, and using more than a few of them may degrade
//     972   performance.
//     973
//     974   The default is set to a value that serves only as a safeguard.
//     975   Setting to 0 disables use of mmap for servicing large requests.
//     976 */
//977
//978 #define M_MMAP_MAX             -4
//979
//980 #ifndef DEFAULT_MMAP_MAX
//981 #define DEFAULT_MMAP_MAX       (65536)
//982 #endif
//983
//984 #include <malloc.h>
//985
//986 #ifndef RETURN_ADDRESS
//987 #define RETURN_ADDRESS(X_) (NULL)
//988 #endif
//989
//990 /* Forward declarations.  */
//991 struct malloc_chunk;
//992 typedef struct malloc_chunk* mchunkptr;
//993
//994 /* Internal routines.  */
//995
//996 static void*  _int_malloc(mstate, size_t);
//997 static void     _int_free(mstate, mchunkptr, int);
//998 static void*  _int_realloc(mstate, mchunkptr, INTERNAL_SIZE_T,
//                               999                            INTERNAL_SIZE_T);
//1000 static void*  _int_memalign(mstate, size_t, size_t);
//1001 static void*  _mid_memalign(size_t, size_t, void *);
//1002
//1003 static void malloc_printerr(const char *str) __attribute__ ((noreturn));
//1004
//1005 static void* mem2mem_check(void *p, size_t sz);
//1006 static void top_check(void);
//1007 static void munmap_chunk(mchunkptr p);
//1008 #if HAVE_MREMAP
//1009 static mchunkptr mremap_chunk(mchunkptr p, size_t new_size);
//1010 #endif
//1011
//1012 static void*   malloc_check(size_t sz, const void *caller);
//1013 static void      free_check(void* mem, const void *caller);
//1014 static void*   realloc_check(void* oldmem, size_t bytes,
//                                  1015                                const void *caller);
//1016 static void*   memalign_check(size_t alignment, size_t bytes,
//                                   1017                                 const void *caller);
//1018
//1019 /* ------------------ MMAP support ------------------  */
//1020
//1021
//1022 #include <fcntl.h>
//1023 #include <sys/mman.h>
//1024
//1025 #if !defined(MAP_ANONYMOUS) && defined(MAP_ANON)
//1026 # define MAP_ANONYMOUS MAP_ANON
//1027 #endif
//1028
//1029 #ifndef MAP_NORESERVE
//1030 # define MAP_NORESERVE 0
//1031 #endif
//1032
//1033 #define MMAP(addr, size, prot, flags) \
//1034  __mmap((addr), (size), (prot), (flags)|MAP_ANONYMOUS|MAP_PRIVATE, -1, 0)
//1035
//1036
//1037 /*
//      1038   -----------------------  Chunk representations -----------------------
//      1039 */
//1040
//1041
//1042 /*
//      1043   This struct declaration is misleading (but accurate and necessary).
//      1044   It declares a "view" into memory allowing access to necessary
//      1045   fields at known offsets from a given base. See explanation below.
//      1046 */
//1047
//1048 struct malloc_chunk {
//    1049
//    1050   INTERNAL_SIZE_T      mchunk_prev_size;  /* Size of previous chunk (if free).  */
//    1051   INTERNAL_SIZE_T      mchunk_size;       /* Size in bytes, including overhead. */
//    1052
//    1053   struct malloc_chunk* fd;         /* double links -- used only if free. */
//    1054   struct malloc_chunk* bk;
//    1055
//    1056   /* Only used for large blocks: pointer to next larger size.  */
//    1057   struct malloc_chunk* fd_nextsize; /* double links -- used only if free. */
//    1058   struct malloc_chunk* bk_nextsize;
//    1059 };
//1060
//1061
//1062 /*
//      1063    malloc_chunk details:
//      1064
//      1065     (The following includes lightly edited explanations by Colin Plumb.)
//      1066
//      1067     Chunks of memory are maintained using a `boundary tag' method as
//      1068     described in e.g., Knuth or Standish.  (See the paper by Paul
//      1069     Wilson ftp://ftp.cs.utexas.edu/pub/garbage/allocsrv.ps for a
//      1070     survey of such techniques.)  Sizes of free chunks are stored both
//      1071     in the front of each chunk and at the end.  This makes
//      1072     consolidating fragmented chunks into bigger chunks very fast.  The
//      1073     size fields also hold bits representing whether chunks are free or
//      1074     in use.
//      1075
//      1076     An allocated chunk looks like this:
//      1077
//      1078
//      1079     chunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1080             |             Size of previous chunk, if unallocated (P clear)  |
//      1081             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1082             |             Size of chunk, in bytes                     |A|M|P|
//      1083       mem-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1084             |             User data starts here...                          .
//      1085             .                                                               .
//      1086             .             (malloc_usable_size() bytes)                      .
//      1087             .                                                               |
//      1088 nextchunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1089             |             (size of chunk, but used for application data)    |
//      1090             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1091             |             Size of next chunk, in bytes                |A|0|1|
//      1092             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1093
//      1094     Where "chunk" is the front of the chunk for the purpose of most of
//      1095     the malloc code, but "mem" is the pointer that is returned to the
//      1096     user.  "Nextchunk" is the beginning of the next contiguous chunk.
//      1097
//      1098     Chunks always begin on even word boundaries, so the mem portion
//      1099     (which is returned to the user) is also on an even word boundary, and
//      1100     thus at least double-word aligned.
//      1101
//      1102     Free chunks are stored in circular doubly-linked lists, and look like this:
//      1103
//      1104     chunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1105             |             Size of previous chunk, if unallocated (P clear)  |
//      1106             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1107     `head:' |             Size of chunk, in bytes                     |A|0|P|
//      1108       mem-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1109             |             Forward pointer to next chunk in list             |
//      1110             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1111             |             Back pointer to previous chunk in list            |
//      1112             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1113             |             Unused space (may be 0 bytes long)                .
//      1114             .                                                               .
//      1115             .                                                               |
//      1116 nextchunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1117     `foot:' |             Size of chunk, in bytes                           |
//      1118             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1119             |             Size of next chunk, in bytes                |A|0|0|
//      1120             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//      1121
//      1122     The P (PREV_INUSE) bit, stored in the unused low-order bit of the
//      1123     chunk size (which is always a multiple of two words), is an in-use
//      1124     bit for the *previous* chunk.  If that bit is *clear*, then the
//      1125     word before the current chunk size contains the previous chunk
//      1126     size, and can be used to find the front of the previous chunk.
//      1127     The very first chunk allocated always has this bit set,
//      1128     preventing access to non-existent (or non-owned) memory. If
//      1129     prev_inuse is set for any given chunk, then you CANNOT determine
//      1130     the size of the previous chunk, and might even get a memory
//      1131     addressing fault when trying to do so.
//      1132
//      1133     The A (NON_MAIN_ARENA) bit is cleared for chunks on the initial,
//      1134     main arena, described by the main_arena variable.  When additional
//      1135     threads are spawned, each thread receives its own arena (up to a
//      1136     configurable limit, after which arenas are reused for multiple
//      1137     threads), and the chunks in these arenas have the A bit set.  To
//      1138     find the arena for a chunk on such a non-main arena, heap_for_ptr
//      1139     performs a bit mask operation and indirection through the ar_ptr
//      1140     member of the per-heap header heap_info (see arena.c).
//      1141
//      1142     Note that the `foot' of the current chunk is actually represented
//      1143     as the prev_size of the NEXT chunk. This makes it easier to
//      1144     deal with alignments etc but can be very confusing when trying
//      1145     to extend or adapt this code.
//      1146
//      1147     The three exceptions to all this are:
//      1148
//      1149      1. The special chunk `top' doesn't bother using the
//      1150         trailing size field since there is no next contiguous chunk
//      1151         that would have to index off it. After initialization, `top'
//      1152         is forced to always exist.  If it would become less than
//      1153         MINSIZE bytes long, it is replenished.
//      1154
//      1155      2. Chunks allocated via mmap, which have the second-lowest-order
//      1156         bit M (IS_MMAPPED) set in their size fields.  Because they are
//      1157         allocated one-by-one, each must contain its own trailing size
//      1158         field.  If the M bit is set, the other bits are ignored
//      1159         (because mmapped chunks are neither in an arena, nor adjacent
//      1160         to a freed chunk).  The M bit is also used for chunks which
//      1161         originally came from a dumped heap via malloc_set_state in
//      1162         hooks.c.
//      1163
//      1164      3. Chunks in fastbins are treated as allocated chunks from the
//      1165         point of view of the chunk allocator.  They are consolidated
//      1166         with their neighbors only in bulk, in malloc_consolidate.
//      1167 */
//1168
//1169 /*
//      1170   ---------- Size and alignment checks and conversions ----------
//      1171 */
//1172
//1173 /* conversion from malloc headers to user pointers, and back */
//1174
//1175 #define chunk2mem(p)   ((void*)((char*)(p) + 2*SIZE_SZ))
//1176 #define mem2chunk(mem) ((mchunkptr)((char*)(mem) - 2*SIZE_SZ))
//1177
//1178 /* The smallest possible chunk */
//1179 #define MIN_CHUNK_SIZE        (offsetof(struct malloc_chunk, fd_nextsize))
//1180
//1181 /* The smallest size we can malloc is an aligned minimal chunk */
//1182
//1183 #define MINSIZE  \
//1184   (unsigned long)(((MIN_CHUNK_SIZE+MALLOC_ALIGN_MASK) & ~MALLOC_ALIGN_MASK))
//1185
//1186 /* Check if m has acceptable alignment */
//1187
//1188 #define aligned_OK(m)  (((unsigned long)(m) & MALLOC_ALIGN_MASK) == 0)
//1189
//1190 #define misaligned_chunk(p) \
//1191   ((uintptr_t)(MALLOC_ALIGNMENT == 2 * SIZE_SZ ? (p) : chunk2mem (p)) \
//        1192    & MALLOC_ALIGN_MASK)
//1193
//1194 /* pad request bytes into a usable size -- internal version */
//1195
//1196 #define request2size(req)                                         \
//1197   (((req) + SIZE_SZ + MALLOC_ALIGN_MASK < MINSIZE)  ?             \
//        1198    MINSIZE :                                                      \
//        1199    ((req) + SIZE_SZ + MALLOC_ALIGN_MASK) & ~MALLOC_ALIGN_MASK)
//1200
//1201 /* Check if REQ overflows when padded and aligned and if the resulting value
//      1202    is less than PTRDIFF_T.  Returns TRUE and the requested size or MINSIZE in
//      1203    case the value is less than MINSIZE on SZ or false if any of the previous
//      1204    check fail.  */
//1205 static inline bool
//1206 checked_request2size (size_t req, size_t *sz) __nonnull (1)
//1207 {
//    1208   if (__glibc_unlikely (req > PTRDIFF_MAX))
//        1209     return false;
//    1210   *sz = request2size (req);
//    1211   return true;
//    1212 }
//1213
//1214 /*
//      1215    --------------- Physical chunk operations ---------------
//      1216  */
//1217
//1218
//1219 /* size field is or'ed with PREV_INUSE when previous adjacent chunk in use */
//1220 #define PREV_INUSE 0x1
//1221
//1222 /* extract inuse bit of previous chunk */
//1223 #define prev_inuse(p)       ((p)->mchunk_size & PREV_INUSE)
//1224
//1225
//1226 /* size field is or'ed with IS_MMAPPED if the chunk was obtained with mmap() */
//1227 #define IS_MMAPPED 0x2
//1228
//1229 /* check for mmap()'ed chunk */
//1230 #define chunk_is_mmapped(p) ((p)->mchunk_size & IS_MMAPPED)
//1231
//1232
//1233 /* size field is or'ed with NON_MAIN_ARENA if the chunk was obtained
//      1234    from a non-main arena.  This is only set immediately before handing
//      1235    the chunk to the user, if necessary.  */
//1236 #define NON_MAIN_ARENA 0x4
//1237
//1238 /* Check for chunk from main arena.  */
//1239 #define chunk_main_arena(p) (((p)->mchunk_size & NON_MAIN_ARENA) == 0)
//1240
//1241 /* Mark a chunk as not being on the main arena.  */
//1242 #define set_non_main_arena(p) ((p)->mchunk_size |= NON_MAIN_ARENA)
//1243
//1244
//1245 /*
//      1246    Bits to mask off when extracting size
//      1247
//      1248    Note: IS_MMAPPED is intentionally not masked off from size field in
//      1249    macros for which mmapped chunks should never be seen. This should
//      1250    cause helpful core dumps to occur if it is tried by accident by
//      1251    people extending or adapting this malloc.
//      1252  */
//1253 #define SIZE_BITS (PREV_INUSE | IS_MMAPPED | NON_MAIN_ARENA)
//1254
//1255 /* Get size, ignoring use bits */
//1256 #define chunksize(p) (chunksize_nomask (p) & ~(SIZE_BITS))
//1257
//1258 /* Like chunksize, but do not mask SIZE_BITS.  */
//1259 #define chunksize_nomask(p)         ((p)->mchunk_size)
//1260
//1261 /* Ptr to next physical malloc_chunk. */
//1262 #define next_chunk(p) ((mchunkptr) (((char *) (p)) + chunksize (p)))
//1263
//1264 /* Size of the chunk below P.  Only valid if !prev_inuse (P).  */
//1265 #define prev_size(p) ((p)->mchunk_prev_size)
//1266
//1267 /* Set the size of the chunk below P.  Only valid if !prev_inuse (P).  */
//1268 #define set_prev_size(p, sz) ((p)->mchunk_prev_size = (sz))
//1269
//1270 /* Ptr to previous physical malloc_chunk.  Only valid if !prev_inuse (P).  */
//1271 #define prev_chunk(p) ((mchunkptr) (((char *) (p)) - prev_size (p)))
//1272
//1273 /* Treat space at ptr + offset as a chunk */
//1274 #define chunk_at_offset(p, s)  ((mchunkptr) (((char *) (p)) + (s)))
//1275
//1276 /* extract p's inuse bit */
//1277 #define inuse(p)                                                              \
//1278   ((((mchunkptr) (((char *) (p)) + chunksize (p)))->mchunk_size) & PREV_INUSE)
//1279
//1280 /* set/clear chunk as being inuse without otherwise disturbing */
//1281 #define set_inuse(p)                                                          \
//1282   ((mchunkptr) (((char *) (p)) + chunksize (p)))->mchunk_size |= PREV_INUSE
//1283
//1284 #define clear_inuse(p)                                                        \
//1285   ((mchunkptr) (((char *) (p)) + chunksize (p)))->mchunk_size &= ~(PREV_INUSE)
//1286
//1287
//1288 /* check/set/clear inuse bits in known places */
//1289 #define inuse_bit_at_offset(p, s)                                             \
//1290   (((mchunkptr) (((char *) (p)) + (s)))->mchunk_size & PREV_INUSE)
//1291
//1292 #define set_inuse_bit_at_offset(p, s)                                         \
//1293   (((mchunkptr) (((char *) (p)) + (s)))->mchunk_size |= PREV_INUSE)
//1294
//1295 #define clear_inuse_bit_at_offset(p, s)                                       \
//1296   (((mchunkptr) (((char *) (p)) + (s)))->mchunk_size &= ~(PREV_INUSE))
//1297
//1298
//1299 /* Set size at head, without disturbing its use bit */
//1300 #define set_head_size(p, s)  ((p)->mchunk_size = (((p)->mchunk_size & SIZE_BITS) | (s)))
//1301
//1302 /* Set size/use field */
//1303 #define set_head(p, s)       ((p)->mchunk_size = (s))
//1304
//1305 /* Set size at footer (only when chunk is not in use) */
//1306 #define set_foot(p, s)       (((mchunkptr) ((char *) (p) + (s)))->mchunk_prev_size = (s))
//1307
//1308
//1309 #pragma GCC poison mchunk_size
//1310 #pragma GCC poison mchunk_prev_size
//1311
//1312 /*
//      1313    -------------------- Internal data structures --------------------
//      1314
//      1315    All internal state is held in an instance of malloc_state defined
//      1316    below. There are no other static variables, except in two optional
//      1317    cases:
//      1318  * If USE_MALLOC_LOCK is defined, the mALLOC_MUTEx declared above.
//      1319  * If mmap doesn't support MAP_ANONYMOUS, a dummy file descriptor
//      1320      for mmap.
//      1321
//      1322    Beware of lots of tricks that minimize the total bookkeeping space
//      1323    requirements. The result is a little over 1K bytes (for 4byte
//      1324    pointers and size_t.)
//      1325  */
//1326
//1327 /*
//      1328    Bins
//      1329
//      1330     An array of bin headers for free chunks. Each bin is doubly
//      1331     linked.  The bins are approximately proportionally (log) spaced.
//      1332     There are a lot of these bins (128). This may look excessive, but
//      1333     works very well in practice.  Most bins hold sizes that are
//      1334     unusual as malloc request sizes, but are more usual for fragments
//      1335     and consolidated sets of chunks, which is what these bins hold, so
//      1336     they can be found quickly.  All procedures maintain the invariant
//      1337     that no consolidated chunk physically borders another one, so each
//      1338     chunk in a list is known to be preceeded and followed by either
//      1339     inuse chunks or the ends of memory.
//      1340
//      1341     Chunks in bins are kept in size order, with ties going to the
//      1342     approximately least recently used chunk. Ordering isn't needed
//      1343     for the small bins, which all contain the same-sized chunks, but
//      1344     facilitates best-fit allocation for larger chunks. These lists
//      1345     are just sequential. Keeping them in order almost never requires
//      1346     enough traversal to warrant using fancier ordered data
//      1347     structures.
//      1348
//      1349     Chunks of the same size are linked with the most
//      1350     recently freed at the front, and allocations are taken from the
//      1351     back.  This results in LRU (FIFO) allocation order, which tends
//      1352     to give each chunk an equal opportunity to be consolidated with
//      1353     adjacent freed chunks, resulting in larger free chunks and less
//      1354     fragmentation.
//      1355
//      1356     To simplify use in double-linked lists, each bin header acts
//      1357     as a malloc_chunk. This avoids special-casing for headers.
//      1358     But to conserve space and improve locality, we allocate
//      1359     only the fd/bk pointers of bins, and then use repositioning tricks
//      1360     to treat these as the fields of a malloc_chunk*.
//      1361  */
//1362
//1363 typedef struct malloc_chunk *mbinptr;
//1364
//1365 /* addressing -- note that bin_at(0) does not exist */
//1366 #define bin_at(m, i) \
//1367   (mbinptr) (((char *) &((m)->bins[((i) - 1) * 2]))                           \
//                  1368              - offsetof (struct malloc_chunk, fd))
//1369
//1370 /* analog of ++bin */
//1371 #define next_bin(b)  ((mbinptr) ((char *) (b) + (sizeof (mchunkptr) << 1)))
//1372
//1373 /* Reminders about list directionality within bins */
//1374 #define first(b)     ((b)->fd)
//1375 #define last(b)      ((b)->bk)
//1376
//1377 /*
//      1378    Indexing
//      1379
//      1380     Bins for sizes < 512 bytes contain chunks of all the same size, spaced
//      1381     8 bytes apart. Larger bins are approximately logarithmically spaced:
//      1382
//      1383     64 bins of size       8
//      1384     32 bins of size      64
//      1385     16 bins of size     512
//      1386      8 bins of size    4096
//      1387      4 bins of size   32768
//      1388      2 bins of size  262144
//      1389      1 bin  of size what's left
//      1390
//      1391     There is actually a little bit of slop in the numbers in bin_index
//      1392     for the sake of speed. This makes no difference elsewhere.
//      1393
//      1394     The bins top out around 1MB because we expect to service large
//      1395     requests via mmap.
//      1396
//      1397     Bin 0 does not exist.  Bin 1 is the unordered list; if that would be
//      1398     a valid chunk size the small bins are bumped up one.
//      1399  */
//1400
//1401 #define NBINS             128
//1402 #define NSMALLBINS         64
//1403 #define SMALLBIN_WIDTH    MALLOC_ALIGNMENT
//1404 #define SMALLBIN_CORRECTION (MALLOC_ALIGNMENT > 2 * SIZE_SZ)
//1405 #define MIN_LARGE_SIZE    ((NSMALLBINS - SMALLBIN_CORRECTION) * SMALLBIN_WIDTH)
//1406
//1407 #define in_smallbin_range(sz)  \
//1408   ((unsigned long) (sz) < (unsigned long) MIN_LARGE_SIZE)
//1409
//1410 #define smallbin_index(sz) \
//1411   ((SMALLBIN_WIDTH == 16 ? (((unsigned) (sz)) >> 4) : (((unsigned) (sz)) >> 3))\
//        1412    + SMALLBIN_CORRECTION)
//1413
//1414 #define largebin_index_32(sz)                                                \
//1415   (((((unsigned long) (sz)) >> 6) <= 38) ?  56 + (((unsigned long) (sz)) >> 6) :\
//        1416    ((((unsigned long) (sz)) >> 9) <= 20) ?  91 + (((unsigned long) (sz)) >> 9) :\
//        1417    ((((unsigned long) (sz)) >> 12) <= 10) ? 110 + (((unsigned long) (sz)) >> 12) :\
//        1418    ((((unsigned long) (sz)) >> 15) <= 4) ? 119 + (((unsigned long) (sz)) >> 15) :\
//        1419    ((((unsigned long) (sz)) >> 18) <= 2) ? 124 + (((unsigned long) (sz)) >> 18) :\
//        1420    126)
//1421
//1422 #define largebin_index_32_big(sz)                                            \
//1423   (((((unsigned long) (sz)) >> 6) <= 45) ?  49 + (((unsigned long) (sz)) >> 6) :\
//        1424    ((((unsigned long) (sz)) >> 9) <= 20) ?  91 + (((unsigned long) (sz)) >> 9) :\
//        1425    ((((unsigned long) (sz)) >> 12) <= 10) ? 110 + (((unsigned long) (sz)) >> 12) :\
//        1426    ((((unsigned long) (sz)) >> 15) <= 4) ? 119 + (((unsigned long) (sz)) >> 15) :\
//        1427    ((((unsigned long) (sz)) >> 18) <= 2) ? 124 + (((unsigned long) (sz)) >> 18) :\
//        1428    126)
//1429
//1430 // XXX It remains to be seen whether it is good to keep the widths of
//1431 // XXX the buckets the same or whether it should be scaled by a factor
//1432 // XXX of two as well.
//1433 #define largebin_index_64(sz)                                                \
//1434   (((((unsigned long) (sz)) >> 6) <= 48) ?  48 + (((unsigned long) (sz)) >> 6) :\
//        1435    ((((unsigned long) (sz)) >> 9) <= 20) ?  91 + (((unsigned long) (sz)) >> 9) :\
//        1436    ((((unsigned long) (sz)) >> 12) <= 10) ? 110 + (((unsigned long) (sz)) >> 12) :\
//        1437    ((((unsigned long) (sz)) >> 15) <= 4) ? 119 + (((unsigned long) (sz)) >> 15) :\
//        1438    ((((unsigned long) (sz)) >> 18) <= 2) ? 124 + (((unsigned long) (sz)) >> 18) :\
//        1439    126)
//1440
//1441 #define largebin_index(sz) \
//1442   (SIZE_SZ == 8 ? largebin_index_64 (sz)                                     \
//        1443    : MALLOC_ALIGNMENT == 16 ? largebin_index_32_big (sz)                     \
//        1444    : largebin_index_32 (sz))
//1445
//1446 #define bin_index(sz) \
//1447   ((in_smallbin_range (sz)) ? smallbin_index (sz) : largebin_index (sz))
//1448
//1449 /* Take a chunk off a bin list.  */
//1450 static void
//1451 unlink_chunk (mstate av, mchunkptr p)
//1452 {
//    1453   if (chunksize (p) != prev_size (next_chunk (p)))
//        1454     malloc_printerr ("corrupted size vs. prev_size");
//        1455
//        1456   mchunkptr fd = p->fd;
//        1457   mchunkptr bk = p->bk;
//        1458
//        1459   if (__builtin_expect (fd->bk != p || bk->fd != p, 0))
//            1460     malloc_printerr ("corrupted double-linked list");
//            1461
//            1462   fd->bk = bk;
//            1463   bk->fd = fd;
//            1464   if (!in_smallbin_range (chunksize_nomask (p)) && p->fd_nextsize != NULL)
//                1465     {
//                    1466       if (p->fd_nextsize->bk_nextsize != p
//                                   1467           || p->bk_nextsize->fd_nextsize != p)
//                        1468         malloc_printerr ("corrupted double-linked list (not small)");
//                    1469
//                    1470       if (fd->fd_nextsize == NULL)
//                        1471         {
//                            1472           if (p->fd_nextsize == p)
//                                1473             fd->fd_nextsize = fd->bk_nextsize = fd;
//                            1474           else
//                                1475             {
//                                    1476               fd->fd_nextsize = p->fd_nextsize;
//                                    1477               fd->bk_nextsize = p->bk_nextsize;
//                                    1478               p->fd_nextsize->bk_nextsize = fd;
//                                    1479               p->bk_nextsize->fd_nextsize = fd;
//                                    1480             }
//                            1481         }
//                    1482       else
//                        1483         {
//                            1484           p->fd_nextsize->bk_nextsize = p->bk_nextsize;
//                            1485           p->bk_nextsize->fd_nextsize = p->fd_nextsize;
//                            1486         }
//                    1487     }
//    1488 }
//1489
//1490 /*
//      1491    Unsorted chunks
//      1492
//      1493     All remainders from chunk splits, as well as all returned chunks,
//      1494     are first placed in the "unsorted" bin. They are then placed
//      1495     in regular bins after malloc gives them ONE chance to be used before
//      1496     binning. So, basically, the unsorted_chunks list acts as a queue,
//      1497     with chunks being placed on it in free (and malloc_consolidate),
//      1498     and taken off (to be either used or placed in bins) in malloc.
//      1499
//      1500     The NON_MAIN_ARENA flag is never set for unsorted chunks, so it
//      1501     does not have to be taken into account in size comparisons.
//      1502  */
//1503
//1504 /* The otherwise unindexable 1-bin is used to hold unsorted chunks. */
//1505 #define unsorted_chunks(M)          (bin_at (M, 1))
//1506
//1507 /*
//      1508    Top
//      1509
//      1510     The top-most available chunk (i.e., the one bordering the end of
//      1511     available memory) is treated specially. It is never included in
//      1512     any bin, is used only if no other chunk is available, and is
//      1513     released back to the system if it is very large (see
//      1514     M_TRIM_THRESHOLD).  Because top initially
//      1515     points to its own bin with initial zero size, thus forcing
//      1516     extension on the first malloc request, we avoid having any special
//      1517     code in malloc to check whether it even exists yet. But we still
//      1518     need to do so when getting memory from system, so we make
//      1519     initial_top treat the bin as a legal but unusable chunk during the
//      1520     interval between initialization and the first call to
//      1521     sysmalloc. (This is somewhat delicate, since it relies on
//      1522     the 2 preceding words to be zero during this interval as well.)
//      1523  */
//1524
//1525 /* Conveniently, the unsorted bin can be used as dummy top on first call */
//1526 #define initial_top(M)              (unsorted_chunks (M))
//1527
//1528 /*
//      1529    Binmap
//      1530
//      1531     To help compensate for the large number of bins, a one-level index
//      1532     structure is used for bin-by-bin searching.  `binmap' is a
//      1533     bitvector recording whether bins are definitely empty so they can
//      1534     be skipped over during during traversals.  The bits are NOT always
//      1535     cleared as soon as bins are empty, but instead only
//      1536     when they are noticed to be empty during traversal in malloc.
//      1537  */
//1538
//1539 /* Conservatively use 32 bits per map word, even if on 64bit system */
//1540 #define BINMAPSHIFT      5
//1541 #define BITSPERMAP       (1U << BINMAPSHIFT)
//1542 #define BINMAPSIZE       (NBINS / BITSPERMAP)
//1543
//1544 #define idx2block(i)     ((i) >> BINMAPSHIFT)
//1545 #define idx2bit(i)       ((1U << ((i) & ((1U << BINMAPSHIFT) - 1))))
//1546
//1547 #define mark_bin(m, i)    ((m)->binmap[idx2block (i)] |= idx2bit (i))
//1548 #define unmark_bin(m, i)  ((m)->binmap[idx2block (i)] &= ~(idx2bit (i)))
//1549 #define get_binmap(m, i)  ((m)->binmap[idx2block (i)] & idx2bit (i))
//1550
//1551 /*
//      1552    Fastbins
//      1553
//      1554     An array of lists holding recently freed small chunks.  Fastbins
//      1555     are not doubly linked.  It is faster to single-link them, and
//      1556     since chunks are never removed from the middles of these lists,
//      1557     double linking is not necessary. Also, unlike regular bins, they
//      1558     are not even processed in FIFO order (they use faster LIFO) since
//      1559     ordering doesn't much matter in the transient contexts in which
//      1560     fastbins are normally used.
//      1561
//      1562     Chunks in fastbins keep their inuse bit set, so they cannot
//      1563     be consolidated with other free chunks. malloc_consolidate
//      1564     releases all chunks in fastbins and consolidates them with
//      1565     other free chunks.
//      1566  */
//1567
//1568 typedef struct malloc_chunk *mfastbinptr;
//1569 #define fastbin(ar_ptr, idx) ((ar_ptr)->fastbinsY[idx])
//1570
//1571 /* offset 2 to use otherwise unindexable first 2 bins */
//1572 #define fastbin_index(sz) \
//1573   ((((unsigned int) (sz)) >> (SIZE_SZ == 8 ? 4 : 3)) - 2)
//1574
//1575
//1576 /* The maximum fastbin request size we support */
//1577 #define MAX_FAST_SIZE     (80 * SIZE_SZ / 4)
//1578
//1579 #define NFASTBINS  (fastbin_index (request2size (MAX_FAST_SIZE)) + 1)
//1580
//1581 /*
//      1582    FASTBIN_CONSOLIDATION_THRESHOLD is the size of a chunk in free()
//      1583    that triggers automatic consolidation of possibly-surrounding
//      1584    fastbin chunks. This is a heuristic, so the exact value should not
//      1585    matter too much. It is defined at half the default trim threshold as a
//      1586    compromise heuristic to only attempt consolidation if it is likely
//      1587    to lead to trimming. However, it is not dynamically tunable, since
//      1588    consolidation reduces fragmentation surrounding large chunks even
//      1589    if trimming is not used.
//      1590  */
//1591
//1592 #define FASTBIN_CONSOLIDATION_THRESHOLD  (65536UL)
//1593
//1594 /*
//      1595    NONCONTIGUOUS_BIT indicates that MORECORE does not return contiguous
//      1596    regions.  Otherwise, contiguity is exploited in merging together,
//      1597    when possible, results from consecutive MORECORE calls.
//      1598
//      1599    The initial value comes from MORECORE_CONTIGUOUS, but is
//      1600    changed dynamically if mmap is ever used as an sbrk substitute.
//      1601  */
//1602
//1603 #define NONCONTIGUOUS_BIT     (2U)
//1604
//1605 #define contiguous(M)          (((M)->flags & NONCONTIGUOUS_BIT) == 0)
//1606 #define noncontiguous(M)       (((M)->flags & NONCONTIGUOUS_BIT) != 0)
//1607 #define set_noncontiguous(M)   ((M)->flags |= NONCONTIGUOUS_BIT)
//1608 #define set_contiguous(M)      ((M)->flags &= ~NONCONTIGUOUS_BIT)
//1609
//1610 /* Maximum size of memory handled in fastbins.  */
//1611 static INTERNAL_SIZE_T global_max_fast;
//1612
//1613 /*
//      1614    Set value of max_fast.
//      1615    Use impossibly small value if 0.
//      1616    Precondition: there are no existing fastbin chunks in the main arena.
//      1617    Since do_check_malloc_state () checks this, we call malloc_consolidate ()
//      1618    before changing max_fast.  Note other arenas will leak their fast bin
//      1619    entries if max_fast is reduced.
//      1620  */
//1621
//1622 #define set_max_fast(s) \
//1623   global_max_fast = (((s) == 0)                                               \
//                          1624                      ? SMALLBIN_WIDTH : ((s + SIZE_SZ) & ~MALLOC_ALIGN_MASK))
//1625
//1626 static inline INTERNAL_SIZE_T
//1627 get_max_fast (void)
//1628 {
//    1629   /* Tell the GCC optimizers that global_max_fast is never larger
//            1630      than MAX_FAST_SIZE.  This avoids out-of-bounds array accesses in
//            1631      _int_malloc after constant propagation of the size parameter.
//            1632      (The code never executes because malloc preserves the
//            1633      global_max_fast invariant, but the optimizers may not recognize
//            1634      this.)  */
//    1635   if (global_max_fast > MAX_FAST_SIZE)
//        1636     __builtin_unreachable ();
//    1637   return global_max_fast;
//    1638 }
//1639
//1640 /*
//      1641    ----------- Internal state representation and initialization -----------
//      1642  */
//1643
//1644 /*
//      1645    have_fastchunks indicates that there are probably some fastbin chunks.
//      1646    It is set true on entering a chunk into any fastbin, and cleared early in
//      1647    malloc_consolidate.  The value is approximate since it may be set when there
//      1648    are no fastbin chunks, or it may be clear even if there are fastbin chunks
//      1649    available.  Given it's sole purpose is to reduce number of redundant calls to
//      1650    malloc_consolidate, it does not affect correctness.  As a result we can safely
//      1651    use relaxed atomic accesses.
//      1652  */
//1653
//1654
//1655 struct malloc_state
//1656 {
//    1657   /* Serialize access.  */
//    1658   __libc_lock_define (, mutex);
//    1659
//    1660   /* Flags (formerly in max_fast).  */
//    1661   int flags;
//    1662
//    1663   /* Set if the fastbin chunks contain recently inserted free blocks.  */
//    1664   /* Note this is a bool but not all targets support atomics on booleans.  */
//    1665   int have_fastchunks;
//    1666
//    1667   /* Fastbins */
//    1668   mfastbinptr fastbinsY[NFASTBINS];
//    1669
//    1670   /* Base of the topmost chunk -- not otherwise kept in a bin */
//    1671   mchunkptr top;
//    1672
//    1673   /* The remainder from the most recent split of a small request */
//    1674   mchunkptr last_remainder;
//    1675
//    1676   /* Normal bins packed as described above */
//    1677   mchunkptr bins[NBINS * 2 - 2];
//    1678
//    1679   /* Bitmap of bins */
//    1680   unsigned int binmap[BINMAPSIZE];
//    1681
//    1682   /* Linked list */
//    1683   struct malloc_state *next;
//    1684
//    1685   /* Linked list for free arenas.  Access to this field is serialized
//            1686      by free_list_lock in arena.c.  */
//    1687   struct malloc_state *next_free;
//    1688
//    1689   /* Number of threads attached to this arena.  0 if the arena is on
//            1690      the free list.  Access to this field is serialized by
//            1691      free_list_lock in arena.c.  */
//    1692   INTERNAL_SIZE_T attached_threads;
//    1693
//    1694   /* Memory allocated from the system in this arena.  */
//    1695   INTERNAL_SIZE_T system_mem;
//    1696   INTERNAL_SIZE_T max_system_mem;
//    1697 };
//1698
//1699 struct malloc_par
//1700 {
//    1701   /* Tunable parameters */
//    1702   unsigned long trim_threshold;
//    1703   INTERNAL_SIZE_T top_pad;
//    1704   INTERNAL_SIZE_T mmap_threshold;
//    1705   INTERNAL_SIZE_T arena_test;
//    1706   INTERNAL_SIZE_T arena_max;
//    1707
//    1708   /* Memory map support */
//    1709   int n_mmaps;
//    1710   int n_mmaps_max;
//    1711   int max_n_mmaps;
//    1712   /* the mmap_threshold is dynamic, until the user sets
//            1713      it manually, at which point we need to disable any
//            1714      dynamic behavior. */
//    1715   int no_dyn_threshold;
//    1716
//    1717   /* Statistics */
//    1718   INTERNAL_SIZE_T mmapped_mem;
//    1719   INTERNAL_SIZE_T max_mmapped_mem;
//    1720
//    1721   /* First address handed out by MORECORE/sbrk.  */
//    1722   char *sbrk_base;
//    1723
//    1724 #if USE_TCACHE
//        1725   /* Maximum number of buckets to use.  */
//        1726   size_t tcache_bins;
//    1727   size_t tcache_max_bytes;
//    1728   /* Maximum number of chunks in each bucket.  */
//    1729   size_t tcache_count;
//    1730   /* Maximum number of chunks to remove from the unsorted list, which
//            1731      aren't used to prefill the cache.  */
//    1732   size_t tcache_unsorted_limit;
//    1733 #endif
//    1734 };
//1735
//1736 /* There are several instances of this struct ("arenas") in this
//      1737    malloc.  If you are adapting this malloc in a way that does NOT use
//      1738    a static or mmapped malloc_state, you MUST explicitly zero-fill it
//      1739    before using. This malloc relies on the property that malloc_state
//      1740    is initialized to all zeroes (as is true of C statics).  */
//1741
//1742 static struct malloc_state main_arena =
//1743 {
//    1744   .mutex = _LIBC_LOCK_INITIALIZER,
//    1745   .next = &main_arena,
//    1746   .attached_threads = 1
//    1747 };
//1748
//1749 /* These variables are used for undumping support.  Chunked are marked
//      1750    as using mmap, but we leave them alone if they fall into this
//      1751    range.  NB: The chunk size for these chunks only includes the
//      1752    initial size field (of SIZE_SZ bytes), there is no trailing size
//      1753    field (unlike with regular mmapped chunks).  */
//1754 static mchunkptr dumped_main_arena_start; /* Inclusive.  */
//1755 static mchunkptr dumped_main_arena_end;   /* Exclusive.  */
//1756
//1757 /* True if the pointer falls into the dumped arena.  Use this after
//      1758    chunk_is_mmapped indicates a chunk is mmapped.  */
//1759 #define DUMPED_MAIN_ARENA_CHUNK(p) \
//1760   ((p) >= dumped_main_arena_start && (p) < dumped_main_arena_end)
//1761
//1762 /* There is only one instance of the malloc parameters.  */
//1763
//1764 static struct malloc_par mp_ =
//1765 {
//    1766   .top_pad = DEFAULT_TOP_PAD,
//    1767   .n_mmaps_max = DEFAULT_MMAP_MAX,
//    1768   .mmap_threshold = DEFAULT_MMAP_THRESHOLD,
//    1769   .trim_threshold = DEFAULT_TRIM_THRESHOLD,
//    1770 #define NARENAS_FROM_NCORES(n) ((n) * (sizeof (long) == 4 ? 2 : 8))
//    1771   .arena_test = NARENAS_FROM_NCORES (1)
//    1772 #if USE_TCACHE
//        1773   ,
//        1774   .tcache_count = TCACHE_FILL_COUNT,
//        1775   .tcache_bins = TCACHE_MAX_BINS,
//        1776   .tcache_max_bytes = tidx2usize (TCACHE_MAX_BINS-1),
//        1777   .tcache_unsorted_limit = 0 /* No limit.  */
//        1778 #endif
//        1779 };
//1780
//1781 /*
//      1782    Initialize a malloc_state struct.
//      1783
//      1784    This is called from ptmalloc_init () or from _int_new_arena ()
//      1785    when creating a new arena.
//      1786  */
//1787
//1788 static void
//1789 malloc_init_state (mstate av)
//1790 {
//    1791   int i;
//    1792   mbinptr bin;
//    1793
//    1794   /* Establish circular links for normal bins */
//    1795   for (i = 1; i < NBINS; ++i)
//        1796     {
//            1797       bin = bin_at (av, i);
//            1798       bin->fd = bin->bk = bin;
//            1799     }
//    1800
//    1801 #if MORECORE_CONTIGUOUS
//        1802   if (av != &main_arena)
//            1803 #endif
//            1804   set_noncontiguous (av);
//            1805   if (av == &main_arena)
//                1806     set_max_fast (DEFAULT_MXFAST);
//                1807   atomic_store_relaxed (&av->have_fastchunks, false);
//                1808
//                1809   av->top = initial_top (av);
//                1810 }
//1811
//1812 /*
//      1813    Other internal utilities operating on mstates
//      1814  */
//1815
//1816 static void *sysmalloc (INTERNAL_SIZE_T, mstate);
//1817 static int      systrim (size_t, mstate);
//1818 static void     malloc_consolidate (mstate);
//1819
//1820
//1821 /* -------------- Early definitions for debugging hooks ---------------- */
//1822
//1823 /* Define and initialize the hook variables.  These weak definitions must
//      1824    appear before any use of the variables in a function (arena.c uses one).  */
//1825 #ifndef weak_variable
//1826 /* In GNU libc we want the hook variables to be weak definitions to
//      1827    avoid a problem with Emacs.  */
//1828 # define weak_variable weak_function
//1829 #endif
//1830
//1831 /* Forward declarations.  */
//1832 static void *malloc_hook_ini (size_t sz,
//                                   1833                               const void *caller) __THROW;
//1834 static void *realloc_hook_ini (void *ptr, size_t sz,
//                                    1835                                const void *caller) __THROW;
//1836 static void *memalign_hook_ini (size_t alignment, size_t sz,
//                                     1837                                 const void *caller) __THROW;
//1838
//1839 #if HAVE_MALLOC_INIT_HOOK
//1840 void weak_variable (*__malloc_initialize_hook) (void) = NULL;
//1841 compat_symbol (libc, __malloc_initialize_hook,
//                    1842                __malloc_initialize_hook, GLIBC_2_0);
//1843 #endif
//1844
//1845 void weak_variable (*__free_hook) (void *__ptr,
//                                        1846                                    const void *) = NULL;
//1847 void *weak_variable (*__malloc_hook)
//1848   (size_t __size, const void *) = malloc_hook_ini;
//1849 void *weak_variable (*__realloc_hook)
//1850   (void *__ptr, size_t __size, const void *)
//1851   = realloc_hook_ini;
//1852 void *weak_variable (*__memalign_hook)
//1853   (size_t __alignment, size_t __size, const void *)
//1854   = memalign_hook_ini;
//1855 void weak_variable (*__after_morecore_hook) (void) = NULL;
//1856
//1857 /* This function is called from the arena shutdown hook, to free the
//      1858    thread cache (if it exists).  */
//1859 static void tcache_thread_shutdown (void);
//1860
//1861 /* ------------------ Testing support ----------------------------------*/
//1862
//1863 static int perturb_byte;
//1864
//1865 static void
//1866 alloc_perturb (char *p, size_t n)
//1867 {
//    1868   if (__glibc_unlikely (perturb_byte))
//        1869     memset (p, perturb_byte ^ 0xff, n);
//        1870 }
//1871
//1872 static void
//1873 free_perturb (char *p, size_t n)
//1874 {
//    1875   if (__glibc_unlikely (perturb_byte))
//        1876     memset (p, perturb_byte, n);
//        1877 }
//1878
//1879
//1880
//1881 #include <stap-probe.h>
//1882
//1883 /* ------------------- Support for multiple arenas -------------------- */
//1884 #include "arena.c"
//1885
//1886 /*
//      1887    Debugging support
//      1888
//      1889    These routines make a number of assertions about the states
//      1890    of data structures that should be true at all times. If any
//      1891    are not true, it's very likely that a user program has somehow
//      1892    trashed memory. (It's also possible that there is a coding error
//      1893    in malloc. In which case, please report it!)
//      1894  */
//1895
//1896 #if !MALLOC_DEBUG
//1897
//1898 # define check_chunk(A, P)
//1899 # define check_free_chunk(A, P)
//1900 # define check_inuse_chunk(A, P)
//1901 # define check_remalloced_chunk(A, P, N)
//1902 # define check_malloced_chunk(A, P, N)
//1903 # define check_malloc_state(A)
//1904
//1905 #else
//1906
//1907 # define check_chunk(A, P)              do_check_chunk (A, P)
//1908 # define check_free_chunk(A, P)         do_check_free_chunk (A, P)
//1909 # define check_inuse_chunk(A, P)        do_check_inuse_chunk (A, P)
//1910 # define check_remalloced_chunk(A, P, N) do_check_remalloced_chunk (A, P, N)
//1911 # define check_malloced_chunk(A, P, N)   do_check_malloced_chunk (A, P, N)
//1912 # define check_malloc_state(A)         do_check_malloc_state (A)
//1913
//1914 /*
//      1915    Properties of all chunks
//      1916  */
//1917
//1918 static void
//1919 do_check_chunk (mstate av, mchunkptr p)
//1920 {
//    1921   unsigned long sz = chunksize (p);
//    1922   /* min and max possible addresses assuming contiguous allocation */
//    1923   char *max_address = (char *) (av->top) + chunksize (av->top);
//    1924   char *min_address = max_address - av->system_mem;
//    1925
//    1926   if (!chunk_is_mmapped (p))
//        1927     {
//            1928       /* Has legal address ... */
//            1929       if (p != av->top)
//                1930         {
//                    1931           if (contiguous (av))
//                        1932             {
//                            1933               assert (((char *) p) >= min_address);
//                            1934               assert (((char *) p + sz) <= ((char *) (av->top)));
//                            1935             }
//                    1936         }
//            1937       else
//                1938         {
//                    1939           /* top size is always at least MINSIZE */
//                    1940           assert ((unsigned long) (sz) >= MINSIZE);
//                    1941           /* top predecessor always marked inuse */
//                    1942           assert (prev_inuse (p));
//                    1943         }
//            1944     }
//    1945   else if (!DUMPED_MAIN_ARENA_CHUNK (p))
//        1946     {
//            1947       /* address is outside main heap  */
//            1948       if (contiguous (av) && av->top != initial_top (av))
//                1949         {
//                    1950           assert (((char *) p) < min_address || ((char *) p) >= max_address);
//                    1951         }
//            1952       /* chunk is page-aligned */
//            1953       assert (((prev_size (p) + sz) & (GLRO (dl_pagesize) - 1)) == 0);
//            1954       /* mem is aligned */
//            1955       assert (aligned_OK (chunk2mem (p)));
//            1956     }
//    1957 }
//1958
//1959 /*
//      1960    Properties of free chunks
//      1961  */
//1962
//1963 static void
//1964 do_check_free_chunk (mstate av, mchunkptr p)
//1965 {
//    1966   INTERNAL_SIZE_T sz = chunksize_nomask (p) & ~(PREV_INUSE | NON_MAIN_ARENA);
//    1967   mchunkptr next = chunk_at_offset (p, sz);
//    1968
//    1969   do_check_chunk (av, p);
//    1970
//    1971   /* Chunk must claim to be free ... */
//    1972   assert (!inuse (p));
//    1973   assert (!chunk_is_mmapped (p));
//    1974
//    1975   /* Unless a special marker, must have OK fields */
//    1976   if ((unsigned long) (sz) >= MINSIZE)
//        1977     {
//            1978       assert ((sz & MALLOC_ALIGN_MASK) == 0);
//            1979       assert (aligned_OK (chunk2mem (p)));
//            1980       /* ... matching footer field */
//            1981       assert (prev_size (next_chunk (p)) == sz);
//            1982       /* ... and is fully consolidated */
//            1983       assert (prev_inuse (p));
//            1984       assert (next == av->top || inuse (next));
//            1985
//            1986       /* ... and has minimally sane links */
//            1987       assert (p->fd->bk == p);
//            1988       assert (p->bk->fd == p);
//            1989     }
//    1990   else /* markers are always of size SIZE_SZ */
//        1991     assert (sz == SIZE_SZ);
//        1992 }
//1993
//1994 /*
//      1995    Properties of inuse chunks
//      1996  */
//1997
//1998 static void
//1999 do_check_inuse_chunk (mstate av, mchunkptr p)
//2000 {
//    2001   mchunkptr next;
//    2002
//    2003   do_check_chunk (av, p);
//    2004
//    2005   if (chunk_is_mmapped (p))
//        2006     return; /* mmapped chunks have no next/prev */
//    2007
//    2008   /* Check whether it claims to be in use ... */
//    2009   assert (inuse (p));
//    2010
//    2011   next = next_chunk (p);
//    2012
//    2013   /* ... and is surrounded by OK chunks.
//            2014      Since more things can be checked with free chunks than inuse ones,
//            2015      if an inuse chunk borders them and debug is on, it's worth doing them.
//            2016    */
//    2017   if (!prev_inuse (p))
//        2018     {
//            2019       /* Note that we cannot even look at prev unless it is not inuse */
//            2020       mchunkptr prv = prev_chunk (p);
//            2021       assert (next_chunk (prv) == p);
//            2022       do_check_free_chunk (av, prv);
//            2023     }
//    2024
//    2025   if (next == av->top)
//        2026     {
//            2027       assert (prev_inuse (next));
//            2028       assert (chunksize (next) >= MINSIZE);
//            2029     }
//    2030   else if (!inuse (next))
//        2031     do_check_free_chunk (av, next);
//        2032 }
//2033
//2034 /*
//      2035    Properties of chunks recycled from fastbins
//      2036  */
//2037
//2038 static void
//2039 do_check_remalloced_chunk (mstate av, mchunkptr p, INTERNAL_SIZE_T s)
//2040 {
//    2041   INTERNAL_SIZE_T sz = chunksize_nomask (p) & ~(PREV_INUSE | NON_MAIN_ARENA);
//    2042
//    2043   if (!chunk_is_mmapped (p))
//        2044     {
//            2045       assert (av == arena_for_chunk (p));
//            2046       if (chunk_main_arena (p))
//                2047         assert (av == &main_arena);
//            2048       else
//                2049         assert (av != &main_arena);
//            2050     }
//    2051
//    2052   do_check_inuse_chunk (av, p);
//    2053
//    2054   /* Legal size ... */
//    2055   assert ((sz & MALLOC_ALIGN_MASK) == 0);
//    2056   assert ((unsigned long) (sz) >= MINSIZE);
//    2057   /* ... and alignment */
//    2058   assert (aligned_OK (chunk2mem (p)));
//    2059   /* chunk is less than MINSIZE more than request */
//    2060   assert ((long) (sz) - (long) (s) >= 0);
//    2061   assert ((long) (sz) - (long) (s + MINSIZE) < 0);
//    2062 }
//2063
//2064 /*
//      2065    Properties of nonrecycled chunks at the point they are malloced
//      2066  */
//2067
//2068 static void
//2069 do_check_malloced_chunk (mstate av, mchunkptr p, INTERNAL_SIZE_T s)
//2070 {
//    2071   /* same as recycled case ... */
//    2072   do_check_remalloced_chunk (av, p, s);
//    2073
//    2074   /*
//            2075      ... plus,  must obey implementation invariant that prev_inuse is
//            2076      always true of any allocated chunk; i.e., that each allocated
//            2077      chunk borders either a previously allocated and still in-use
//            2078      chunk, or the base of its memory arena. This is ensured
//            2079      by making all allocations from the `lowest' part of any found
//            2080      chunk.  This does not necessarily hold however for chunks
//            2081      recycled via fastbins.
//            2082    */
//    2083
//    2084   assert (prev_inuse (p));
//    2085 }
//2086
//2087
//2088 /*
//      2089    Properties of malloc_state.
//      2090
//      2091    This may be useful for debugging malloc, as well as detecting user
//      2092    programmer errors that somehow write into malloc_state.
//      2093
//      2094    If you are extending or experimenting with this malloc, you can
//      2095    probably figure out how to hack this routine to print out or
//      2096    display chunk addresses, sizes, bins, and other instrumentation.
//      2097  */
//2098
//2099 static void
//2100 do_check_malloc_state (mstate av)
//2101 {
//    2102   int i;
//    2103   mchunkptr p;
//    2104   mchunkptr q;
//    2105   mbinptr b;
//    2106   unsigned int idx;
//    2107   INTERNAL_SIZE_T size;
//    2108   unsigned long total = 0;
//    2109   int max_fast_bin;
//    2110
//    2111   /* internal size_t must be no wider than pointer type */
//    2112   assert (sizeof (INTERNAL_SIZE_T) <= sizeof (char *));
//    2113
//    2114   /* alignment is a power of 2 */
//    2115   assert ((MALLOC_ALIGNMENT & (MALLOC_ALIGNMENT - 1)) == 0);
//    2116
//    2117   /* Check the arena is initialized. */
//    2118   assert (av->top != 0);
//    2119
//    2120   /* No memory has been allocated yet, so doing more tests is not possible.  */
//    2121   if (av->top == initial_top (av))
//        2122     return;
//    2123
//    2124   /* pagesize is a power of 2 */
//    2125   assert (powerof2(GLRO (dl_pagesize)));
//    2126
//    2127   /* A contiguous main_arena is consistent with sbrk_base.  */
//    2128   if (av == &main_arena && contiguous (av))
//        2129     assert ((char *) mp_.sbrk_base + av->system_mem ==
//                         2130             (char *) av->top + chunksize (av->top));
//        2131
//        2132   /* properties of fastbins */
//        2133
//        2134   /* max_fast is in allowed range */
//        2135   assert ((get_max_fast () & ~1) <= request2size (MAX_FAST_SIZE));
//        2136
//        2137   max_fast_bin = fastbin_index (get_max_fast ());
//        2138
//        2139   for (i = 0; i < NFASTBINS; ++i)
//            2140     {
//                2141       p = fastbin (av, i);
//                2142
//                2143       /* The following test can only be performed for the main arena.
//                            2144          While mallopt calls malloc_consolidate to get rid of all fast
//                            2145          bins (especially those larger than the new maximum) this does
//                            2146          only happen for the main arena.  Trying to do this for any
//                            2147          other arena would mean those arenas have to be locked and
//                            2148          malloc_consolidate be called for them.  This is excessive.  And
//                            2149          even if this is acceptable to somebody it still cannot solve
//                            2150          the problem completely since if the arena is locked a
//                            2151          concurrent malloc call might create a new arena which then
//                            2152          could use the newly invalid fast bins.  */
//                2153
//                2154       /* all bins past max_fast are empty */
//                2155       if (av == &main_arena && i > max_fast_bin)
//                    2156         assert (p == 0);
//                2157
//                2158       while (p != 0)
//                    2159         {
//                        2160           /* each chunk claims to be inuse */
//                        2161           do_check_inuse_chunk (av, p);
//                        2162           total += chunksize (p);
//                        2163           /* chunk belongs in this bin */
//                        2164           assert (fastbin_index (chunksize (p)) == i);
//                        2165           p = p->fd;
//                        2166         }
//                2167     }
//    2168
//    2169   /* check normal bins */
//    2170   for (i = 1; i < NBINS; ++i)
//        2171     {
//            2172       b = bin_at (av, i);
//            2173
//            2174       /* binmap is accurate (except for bin 1 == unsorted_chunks) */
//            2175       if (i >= 2)
//                2176         {
//                    2177           unsigned int binbit = get_binmap (av, i);
//                    2178           int empty = last (b) == b;
//                    2179           if (!binbit)
//                        2180             assert (empty);
//                    2181           else if (!empty)
//                        2182             assert (binbit);
//                    2183         }
//            2184
//            2185       for (p = last (b); p != b; p = p->bk)
//                2186         {
//                    2187           /* each chunk claims to be free */
//                    2188           do_check_free_chunk (av, p);
//                    2189           size = chunksize (p);
//                    2190           total += size;
//                    2191           if (i >= 2)
//                        2192             {
//                            2193               /* chunk belongs in bin */
//                            2194               idx = bin_index (size);
//                            2195               assert (idx == i);
//                            2196               /* lists are sorted */
//                            2197               assert (p->bk == b ||
//                                                       2198                       (unsigned long) chunksize (p->bk) >= (unsigned long) chunksize (p));
//                            2199
//                            2200               if (!in_smallbin_range (size))
//                                2201                 {
//                                    2202                   if (p->fd_nextsize != NULL)
//                                        2203                     {
//                                            2204                       if (p->fd_nextsize == p)
//                                                2205                         assert (p->bk_nextsize == p);
//                                            2206                       else
//                                                2207                         {
//                                                    2208                           if (p->fd_nextsize == first (b))
//                                                        2209                             assert (chunksize (p) < chunksize (p->fd_nextsize));
//                                                    2210                           else
//                                                        2211                             assert (chunksize (p) > chunksize (p->fd_nextsize));
//                                                    2212
//                                                    2213                           if (p == first (b))
//                                                        2214                             assert (chunksize (p) > chunksize (p->bk_nextsize));
//                                                    2215                           else
//                                                        2216                             assert (chunksize (p) < chunksize (p->bk_nextsize));
//                                                    2217                         }
//                                            2218                     }
//                                    2219                   else
//                                        2220                     assert (p->bk_nextsize == NULL);
//                                    2221                 }
//                            2222             }
//                    2223           else if (!in_smallbin_range (size))
//                        2224             assert (p->fd_nextsize == NULL && p->bk_nextsize == NULL);
//                    2225           /* chunk is followed by a legal chain of inuse chunks */
//                    2226           for (q = next_chunk (p);
//                                        2227                (q != av->top && inuse (q) &&
//                                                             2228                 (unsigned long) (chunksize (q)) >= MINSIZE);
//                                        2229                q = next_chunk (q))
//                        2230             do_check_inuse_chunk (av, q);
//                    2231         }
//            2232     }
//    2233
//    2234   /* top chunk is OK */
//    2235   check_chunk (av, av->top);
//    2236 }
//2237 #endif
//2238
//2239
//2240 /* ----------------- Support for debugging hooks -------------------- */
//2241 #include "hooks.c"
//2242
//2243
//2244 /* ----------- Routines dealing with system allocation -------------- */
//2245
//2246 /*
//      2247    sysmalloc handles malloc cases requiring more memory from the system.
//      2248    On entry, it is assumed that av->top does not have enough
//      2249    space to service request for nb bytes, thus requiring that av->top
//      2250    be extended or replaced.
//      2251  */
//2252
//2253 static void *
//2254 sysmalloc (INTERNAL_SIZE_T nb, mstate av)
//2255 {
//    2256   mchunkptr old_top;              /* incoming value of av->top */
//    2257   INTERNAL_SIZE_T old_size;       /* its size */
//    2258   char *old_end;                  /* its end address */
//    2259
//    2260   long size;                      /* arg to first MORECORE or mmap call */
//    2261   char *brk;                      /* return value from MORECORE */
//    2262
//    2263   long correction;                /* arg to 2nd MORECORE call */
//    2264   char *snd_brk;                  /* 2nd return val */
//    2265
//    2266   INTERNAL_SIZE_T front_misalign; /* unusable bytes at front of new space */
//    2267   INTERNAL_SIZE_T end_misalign;   /* partial page left at end of new space */
//    2268   char *aligned_brk;              /* aligned offset into brk */
//    2269
//    2270   mchunkptr p;                    /* the allocated/returned chunk */
//    2271   mchunkptr remainder;            /* remainder from allocation */
//    2272   unsigned long remainder_size;   /* its size */
//    2273
//    2274
//    2275   size_t pagesize = GLRO (dl_pagesize);
//    2276   bool tried_mmap = false;
//    2277
//    2278
//    2279   /*
//            2280      If have mmap, and the request size meets the mmap threshold, and
//            2281      the system supports mmap, and there are few enough currently
//            2282      allocated mmapped regions, try to directly map this request
//            2283      rather than expanding top.
//            2284    */
//    2285
//    2286   if (av == NULL
//               2287       || ((unsigned long) (nb) >= (unsigned long) (mp_.mmap_threshold)
//                              2288           && (mp_.n_mmaps < mp_.n_mmaps_max)))
//        2289     {
//            2290       char *mm;           /* return value from mmap call*/
//            2291
//            2292     try_mmap:
//            2293       /*
//                        2294          Round up size to nearest page.  For mmapped chunks, the overhead
//                        2295          is one SIZE_SZ unit larger than for normal chunks, because there
//                        2296          is no following chunk whose prev_size field could be used.
//                        2297
//                        2298          See the front_misalign handling below, for glibc there is no
//                        2299          need for further alignments unless we have have high alignment.
//                        2300        */
//            2301       if (MALLOC_ALIGNMENT == 2 * SIZE_SZ)
//                2302         size = ALIGN_UP (nb + SIZE_SZ, pagesize);
//            2303       else
//                2304         size = ALIGN_UP (nb + SIZE_SZ + MALLOC_ALIGN_MASK, pagesize);
//            2305       tried_mmap = true;
//            2306
//            2307       /* Don't try if size wraps around 0 */
//            2308       if ((unsigned long) (size) > (unsigned long) (nb))
//                2309         {
//                    2310           mm = (char *) (MMAP (0, size, PROT_READ | PROT_WRITE, 0));
//                    2311
//                    2312           if (mm != MAP_FAILED)
//                        2313             {
//                            2314               /*
//                                                2315                  The offset to the start of the mmapped region is stored
//                                                2316                  in the prev_size field of the chunk. This allows us to adjust
//                                                2317                  returned start address to meet alignment requirements here
//                                                2318                  and in memalign(), and still be able to compute proper
//                                                2319                  address argument for later munmap in free() and realloc().
//                                                2320                */
//                            2321
//                            2322               if (MALLOC_ALIGNMENT == 2 * SIZE_SZ)
//                                2323                 {
//                                    2324                   /* For glibc, chunk2mem increases the address by 2*SIZE_SZ and
//                                                            2325                      MALLOC_ALIGN_MASK is 2*SIZE_SZ-1.  Each mmap'ed area is page
//                                                            2326                      aligned and therefore definitely MALLOC_ALIGN_MASK-aligned.  */
//                                    2327                   assert (((INTERNAL_SIZE_T) chunk2mem (mm) & MALLOC_ALIGN_MASK) == 0);
//                                    2328                   front_misalign = 0;
//                                    2329                 }
//                            2330               else
//                                2331                 front_misalign = (INTERNAL_SIZE_T) chunk2mem (mm) & MALLOC_ALIGN_MASK;
//                            2332               if (front_misalign > 0)
//                                2333                 {
//                                    2334                   correction = MALLOC_ALIGNMENT - front_misalign;
//                                    2335                   p = (mchunkptr) (mm + correction);
//                                    2336                   set_prev_size (p, correction);
//                                    2337                   set_head (p, (size - correction) | IS_MMAPPED);
//                                    2338                 }
//                            2339               else
//                                2340                 {
//                                    2341                   p = (mchunkptr) mm;
//                                    2342                   set_prev_size (p, 0);
//                                    2343                   set_head (p, size | IS_MMAPPED);
//                                    2344                 }
//                            2345
//                            2346               /* update statistics */
//                            2347
//                            2348               int new = atomic_exchange_and_add (&mp_.n_mmaps, 1) + 1;
//                            2349               atomic_max (&mp_.max_n_mmaps, new);
//                            2350
//                            2351               unsigned long sum;
//                            2352               sum = atomic_exchange_and_add (&mp_.mmapped_mem, size) + size;
//                            2353               atomic_max (&mp_.max_mmapped_mem, sum);
//                            2354
//                            2355               check_chunk (av, p);
//                            2356
//                            2357               return chunk2mem (p);
//                            2358             }
//                    2359         }
//            2360     }
//    2361
//    2362   /* There are no usable arenas and mmap also failed.  */
//    2363   if (av == NULL)
//        2364     return 0;
//    2365
//    2366   /* Record incoming configuration of top */
//    2367
//    2368   old_top = av->top;
//    2369   old_size = chunksize (old_top);
//    2370   old_end = (char *) (chunk_at_offset (old_top, old_size));
//    2371
//    2372   brk = snd_brk = (char *) (MORECORE_FAILURE);
//    2373
//    2374   /*
//            2375      If not the first time through, we require old_size to be
//            2376      at least MINSIZE and to have prev_inuse set.
//            2377    */
//    2378
//    2379   assert ((old_top == initial_top (av) && old_size == 0) ||
//                   2380           ((unsigned long) (old_size) >= MINSIZE &&
//                                   2381            prev_inuse (old_top) &&
//                                   2382            ((unsigned long) old_end & (pagesize - 1)) == 0));
//    2383
//    2384   /* Precondition: not enough current space to satisfy nb request */
//    2385   assert ((unsigned long) (old_size) < (unsigned long) (nb + MINSIZE));
//    2386
//    2387
//    2388   if (av != &main_arena)
//        2389     {
//            2390       heap_info *old_heap, *heap;
//            2391       size_t old_heap_size;
//            2392
//            2393       /* First try to extend the current heap. */
//            2394       old_heap = heap_for_ptr (old_top);
//            2395       old_heap_size = old_heap->size;
//            2396       if ((long) (MINSIZE + nb - old_size) > 0
//                           2397           && grow_heap (old_heap, MINSIZE + nb - old_size) == 0)
//                2398         {
//                    2399           av->system_mem += old_heap->size - old_heap_size;
//                    2400           set_head (old_top, (((char *) old_heap + old_heap->size) - (char *) old_top)
//                                             2401                     | PREV_INUSE);
//                    2402         }
//            2403       else if ((heap = new_heap (nb + (MINSIZE + sizeof (*heap)), mp_.top_pad)))
//                2404         {
//                    2405           /* Use a newly allocated heap.  */
//                    2406           heap->ar_ptr = av;
//                    2407           heap->prev = old_heap;
//                    2408           av->system_mem += heap->size;
//                    2409           /* Set up the new top.  */
//                    2410           top (av) = chunk_at_offset (heap, sizeof (*heap));
//                    2411           set_head (top (av), (heap->size - sizeof (*heap)) | PREV_INUSE);
//                    2412
//                    2413           /* Setup fencepost and free the old top chunk with a multiple of
//                                    2414              MALLOC_ALIGNMENT in size. */
//                    2415           /* The fencepost takes at least MINSIZE bytes, because it might
//                                    2416              become the top chunk again later.  Note that a footer is set
//                                    2417              up, too, although the chunk is marked in use. */
//                    2418           old_size = (old_size - MINSIZE) & ~MALLOC_ALIGN_MASK;
//                    2419           set_head (chunk_at_offset (old_top, old_size + 2 * SIZE_SZ), 0 | PREV_INUSE);
//                    2420           if (old_size >= MINSIZE)
//                        2421             {
//                            2422               set_head (chunk_at_offset (old_top, old_size), (2 * SIZE_SZ) | PREV_INUSE);
//                            2423               set_foot (chunk_at_offset (old_top, old_size), (2 * SIZE_SZ));
//                            2424               set_head (old_top, old_size | PREV_INUSE | NON_MAIN_ARENA);
//                            2425               _int_free (av, old_top, 1);
//                            2426             }
//                    2427           else
//                        2428             {
//                            2429               set_head (old_top, (old_size + 2 * SIZE_SZ) | PREV_INUSE);
//                            2430               set_foot (old_top, (old_size + 2 * SIZE_SZ));
//                            2431             }
//                    2432         }
//            2433       else if (!tried_mmap)
//                2434         /* We can at least try to use to mmap memory.  */
//                2435         goto try_mmap;
//            2436     }
//    2437   else     /* av == main_arena */
//        2438
//        2439
//        2440     { /* Request enough space for nb + pad + overhead */
//            2441       size = nb + mp_.top_pad + MINSIZE;
//            2442
//            2443       /*
//                        2444          If contiguous, we can subtract out existing space that we hope to
//                        2445          combine with new space. We add it back later only if
//                        2446          we don't actually get contiguous space.
//                        2447        */
//            2448
//            2449       if (contiguous (av))
//                2450         size -= old_size;
//            2451
//            2452       /*
//                        2453          Round to a multiple of page size.
//                        2454          If MORECORE is not contiguous, this ensures that we only call it
//                        2455          with whole-page arguments.  And if MORECORE is contiguous and
//                        2456          this is not first time through, this preserves page-alignment of
//                        2457          previous calls. Otherwise, we correct to page-align below.
//                        2458        */
//            2459
//            2460       size = ALIGN_UP (size, pagesize);
//            2461
//            2462       /*
//                        2463          Don't try to call MORECORE if argument is so big as to appear
//                        2464          negative. Note that since mmap takes size_t arg, it may succeed
//                        2465          below even if we cannot call MORECORE.
//                        2466        */
//            2467
//            2468       if (size > 0)
//                2469         {
//                    2470           brk = (char *) (MORECORE (size));
//                    2471           LIBC_PROBE (memory_sbrk_more, 2, brk, size);
//                    2472         }
//            2473
//            2474       if (brk != (char *) (MORECORE_FAILURE))
//                2475         {
//                    2476           /* Call the `morecore' hook if necessary.  */
//                    2477           void (*hook) (void) = atomic_forced_read (__after_morecore_hook);
//                    2478           if (__builtin_expect (hook != NULL, 0))
//                        2479             (*hook)();
//                    2480         }
//            2481       else
//                2482         {
//                    2483           /*
//                                    2484              If have mmap, try using it as a backup when MORECORE fails or
//                                    2485              cannot be used. This is worth doing on systems that have "holes" in
//                                    2486              address space, so sbrk cannot extend to give contiguous space, but
//                                    2487              space is available elsewhere.  Note that we ignore mmap max count
//                                    2488              and threshold limits, since the space will not be used as a
//                                    2489              segregated mmap region.
//                                    2490            */
//                    2491
//                    2492           /* Cannot merge with old top, so add its size back in */
//                    2493           if (contiguous (av))
//                        2494             size = ALIGN_UP (size + old_size, pagesize);
//                    2495
//                    2496           /* If we are relying on mmap as backup, then use larger units */
//                    2497           if ((unsigned long) (size) < (unsigned long) (MMAP_AS_MORECORE_SIZE))
//                        2498             size = MMAP_AS_MORECORE_SIZE;
//                    2499
//                    2500           /* Don't try if size wraps around 0 */
//                    2501           if ((unsigned long) (size) > (unsigned long) (nb))
//                        2502             {
//                            2503               char *mbrk = (char *) (MMAP (0, size, PROT_READ | PROT_WRITE, 0));
//                            2504
//                            2505               if (mbrk != MAP_FAILED)
//                                2506                 {
//                                    2507                   /* We do not need, and cannot use, another sbrk call to find end */
//                                    2508                   brk = mbrk;
//                                    2509                   snd_brk = brk + size;
//                                    2510
//                                    2511                   /*
//                                                            2512                      Record that we no longer have a contiguous sbrk region.
//                                                            2513                      After the first time mmap is used as backup, we do not
//                                                            2514                      ever rely on contiguous space since this could incorrectly
//                                                            2515                      bridge regions.
//                                                            2516                    */
//                                    2517                   set_noncontiguous (av);
//                                    2518                 }
//                            2519             }
//                    2520         }
//            2521
//            2522       if (brk != (char *) (MORECORE_FAILURE))
//                2523         {
//                    2524           if (mp_.sbrk_base == 0)
//                        2525             mp_.sbrk_base = brk;
//                    2526           av->system_mem += size;
//                    2527
//                    2528           /*
//                                    2529              If MORECORE extends previous space, we can likewise extend top size.
//                                    2530            */
//                    2531
//                    2532           if (brk == old_end && snd_brk == (char *) (MORECORE_FAILURE))
//                        2533             set_head (old_top, (size + old_size) | PREV_INUSE);
//                    2534
//                    2535           else if (contiguous (av) && old_size && brk < old_end)
//                        2536             /* Oops!  Someone else killed our space..  Can't touch anything.  */
//                        2537             malloc_printerr ("break adjusted to free malloc space");
//                    2538
//                    2539           /*
//                                    2540              Otherwise, make adjustments:
//                                    2541
//                                    2542            * If the first time through or noncontiguous, we need to call sbrk
//                                    2543               just to find out where the end of memory lies.
//                                    2544
//                                    2545            * We need to ensure that all returned chunks from malloc will meet
//                                    2546               MALLOC_ALIGNMENT
//                                    2547
//                                    2548            * If there was an intervening foreign sbrk, we need to adjust sbrk
//                                    2549               request size to account for fact that we will not be able to
//                                    2550               combine new space with existing space in old_top.
//                                    2551
//                                    2552            * Almost all systems internally allocate whole pages at a time, in
//                                    2553               which case we might as well use the whole last page of request.
//                                    2554               So we allocate enough more memory to hit a page boundary now,
//                                    2555               which in turn causes future contiguous calls to page-align.
//                                    2556            */
//                    2557
//                    2558           else
//                        2559             {
//                            2560               front_misalign = 0;
//                            2561               end_misalign = 0;
//                            2562               correction = 0;
//                            2563               aligned_brk = brk;
//                            2564
//                            2565               /* handle contiguous cases */
//                            2566               if (contiguous (av))
//                                2567                 {
//                                    2568                   /* Count foreign sbrk as system_mem.  */
//                                    2569                   if (old_size)
//                                        2570                     av->system_mem += brk - old_end;
//                                    2571
//                                    2572                   /* Guarantee alignment of first new chunk made from this space */
//                                    2573
//                                    2574                   front_misalign = (INTERNAL_SIZE_T) chunk2mem (brk) & MALLOC_ALIGN_MASK;
//                                    2575                   if (front_misalign > 0)
//                                        2576                     {
//                                            2577                       /*
//                                                                        2578                          Skip over some bytes to arrive at an aligned position.
//                                                                        2579                          We don't need to specially mark these wasted front bytes.
//                                                                        2580                          They will never be accessed anyway because
//                                                                        2581                          prev_inuse of av->top (and any chunk created from its start)
//                                                                        2582                          is always true after initialization.
//                                                                        2583                        */
//                                            2584
//                                            2585                       correction = MALLOC_ALIGNMENT - front_misalign;
//                                            2586                       aligned_brk += correction;
//                                            2587                     }
//                                    2588
//                                    2589                   /*
//                                                            2590                      If this isn't adjacent to existing space, then we will not
//                                                            2591                      be able to merge with old_top space, so must add to 2nd request.
//                                                            2592                    */
//                                    2593
//                                    2594                   correction += old_size;
//                                    2595
//                                    2596                   /* Extend the end address to hit a page boundary */
//                                    2597                   end_misalign = (INTERNAL_SIZE_T) (brk + size + correction);
//                                    2598                   correction += (ALIGN_UP (end_misalign, pagesize)) - end_misalign;
//                                    2599
//                                    2600                   assert (correction >= 0);
//                                    2601                   snd_brk = (char *) (MORECORE (correction));
//                                    2602
//                                    2603                   /*
//                                                            2604                      If can't allocate correction, try to at least find out current
//                                                            2605                      brk.  It might be enough to proceed without failing.
//                                                            2606
//                                                            2607                      Note that if second sbrk did NOT fail, we assume that space
//                                                            2608                      is contiguous with first sbrk. This is a safe assumption unless
//                                                            2609                      program is multithreaded but doesn't use locks and a foreign sbrk
//                                                            2610                      occurred between our first and second calls.
//                                                            2611                    */
//                                    2612
//                                    2613                   if (snd_brk == (char *) (MORECORE_FAILURE))
//                                        2614                     {
//                                            2615                       correction = 0;
//                                            2616                       snd_brk = (char *) (MORECORE (0));
//                                            2617                     }
//                                    2618                   else
//                                        2619                     {
//                                            2620                       /* Call the `morecore' hook if necessary.  */
//                                            2621                       void (*hook) (void) = atomic_forced_read (__after_morecore_hook);
//                                            2622                       if (__builtin_expect (hook != NULL, 0))
//                                                2623                         (*hook)();
//                                            2624                     }
//                                    2625                 }
//                            2626
//                            2627               /* handle non-contiguous cases */
//                            2628               else
//                                2629                 {
//                                    2630                   if (MALLOC_ALIGNMENT == 2 * SIZE_SZ)
//                                        2631                     /* MORECORE/mmap must correctly align */
//                                        2632                     assert (((unsigned long) chunk2mem (brk) & MALLOC_ALIGN_MASK) == 0);
//                                    2633                   else
//                                        2634                     {
//                                            2635                       front_misalign = (INTERNAL_SIZE_T) chunk2mem (brk) & MALLOC_ALIGN_MASK;
//                                            2636                       if (front_misalign > 0)
//                                                2637                         {
//                                                    2638                           /*
//                                                                                    2639                              Skip over some bytes to arrive at an aligned position.
//                                                                                    2640                              We don't need to specially mark these wasted front bytes.
//                                                                                    2641                              They will never be accessed anyway because
//                                                                                    2642                              prev_inuse of av->top (and any chunk created from its start)
//                                                                                    2643                              is always true after initialization.
//                                                                                    2644                            */
//                                                    2645
//                                                    2646                           aligned_brk += MALLOC_ALIGNMENT - front_misalign;
//                                                    2647                         }
//                                            2648                     }
//                                    2649
//                                    2650                   /* Find out current end of memory */
//                                    2651                   if (snd_brk == (char *) (MORECORE_FAILURE))
//                                        2652                     {
//                                            2653                       snd_brk = (char *) (MORECORE (0));
//                                            2654                     }
//                                    2655                 }
//                            2656
//                            2657               /* Adjust top based on results of second sbrk */
//                            2658               if (snd_brk != (char *) (MORECORE_FAILURE))
//                                2659                 {
//                                    2660                   av->top = (mchunkptr) aligned_brk;
//                                    2661                   set_head (av->top, (snd_brk - aligned_brk + correction) | PREV_INUSE);
//                                    2662                   av->system_mem += correction;
//                                    2663
//                                    2664                   /*
//                                                            2665                      If not the first time through, we either have a
//                                                            2666                      gap due to foreign sbrk or a non-contiguous region.  Insert a
//                                                            2667                      double fencepost at old_top to prevent consolidation with space
//                                                            2668                      we don't own. These fenceposts are artificial chunks that are
//                                                            2669                      marked as inuse and are in any case too small to use.  We need
//                                                            2670                      two to make sizes and alignments work out.
//                                                            2671                    */
//                                    2672
//                                    2673                   if (old_size != 0)
//                                        2674                     {
//                                            2675                       /*
//                                                                        2676                          Shrink old_top to insert fenceposts, keeping size a
//                                                                        2677                          multiple of MALLOC_ALIGNMENT. We know there is at least
//                                                                        2678                          enough space in old_top to do this.
//                                                                        2679                        */
//                                            2680                       old_size = (old_size - 4 * SIZE_SZ) & ~MALLOC_ALIGN_MASK;
//                                            2681                       set_head (old_top, old_size | PREV_INUSE);
//                                            2682
//                                            2683                       /*
//                                                                        2684                          Note that the following assignments completely overwrite
//                                                                        2685                          old_top when old_size was previously MINSIZE.  This is
//                                                                        2686                          intentional. We need the fencepost, even if old_top otherwise gets
//                                                                        2687                          lost.
//                                                                        2688                        */
//                                            2689                       set_head (chunk_at_offset (old_top, old_size),
//                                                                                 2690                                 (2 * SIZE_SZ) | PREV_INUSE);
//                                            2691                       set_head (chunk_at_offset (old_top, old_size + 2 * SIZE_SZ),
//                                                                                 2692                                 (2 * SIZE_SZ) | PREV_INUSE);
//                                            2693
//                                            2694                       /* If possible, release the rest. */
//                                            2695                       if (old_size >= MINSIZE)
//                                                2696                         {
//                                                    2697                           _int_free (av, old_top, 1);
//                                                    2698                         }
//                                            2699                     }
//                                    2700                 }
//                            2701             }
//                    2702         }
//            2703     } /* if (av !=  &main_arena) */
//    2704
//    2705   if ((unsigned long) av->system_mem > (unsigned long) (av->max_system_mem))
//        2706     av->max_system_mem = av->system_mem;
//        2707   check_malloc_state (av);
//        2708
//        2709   /* finally, do the allocation */
//        2710   p = av->top;
//        2711   size = chunksize (p);
//        2712
//        2713   /* check that one of the above allocation paths succeeded */
//        2714   if ((unsigned long) (size) >= (unsigned long) (nb + MINSIZE))
//            2715     {
//                2716       remainder_size = size - nb;
//                2717       remainder = chunk_at_offset (p, nb);
//                2718       av->top = remainder;
//                2719       set_head (p, nb | PREV_INUSE | (av != &main_arena ? NON_MAIN_ARENA : 0));
//                2720       set_head (remainder, remainder_size | PREV_INUSE);
//                2721       check_malloced_chunk (av, p, nb);
//                2722       return chunk2mem (p);
//                2723     }
//    2724
//    2725   /* catch all failure paths */
//    2726   __set_errno (ENOMEM);
//    2727   return 0;
//    2728 }
//2729
//2730
//2731 /*
//      2732    systrim is an inverse of sorts to sysmalloc.  It gives memory back
//      2733    to the system (via negative arguments to sbrk) if there is unused
//      2734    memory at the `high' end of the malloc pool. It is called
//      2735    automatically by free() when top space exceeds the trim
//      2736    threshold. It is also called by the public malloc_trim routine.  It
//      2737    returns 1 if it actually released any memory, else 0.
//      2738  */
//2739
//2740 static int
//2741 systrim (size_t pad, mstate av)
//2742 {
//    2743   long top_size;         /* Amount of top-most memory */
//    2744   long extra;            /* Amount to release */
//    2745   long released;         /* Amount actually released */
//    2746   char *current_brk;     /* address returned by pre-check sbrk call */
//    2747   char *new_brk;         /* address returned by post-check sbrk call */
//    2748   size_t pagesize;
//    2749   long top_area;
//    2750
//    2751   pagesize = GLRO (dl_pagesize);
//    2752   top_size = chunksize (av->top);
//    2753
//    2754   top_area = top_size - MINSIZE - 1;
//    2755   if (top_area <= pad)
//        2756     return 0;
//    2757
//    2758   /* Release in pagesize units and round down to the nearest page.  */
//    2759   extra = ALIGN_DOWN(top_area - pad, pagesize);
//    2760
//    2761   if (extra == 0)
//        2762     return 0;
//    2763
//    2764   /*
//            2765      Only proceed if end of memory is where we last set it.
//            2766      This avoids problems if there were foreign sbrk calls.
//            2767    */
//    2768   current_brk = (char *) (MORECORE (0));
//    2769   if (current_brk == (char *) (av->top) + top_size)
//        2770     {
//            2771       /*
//                        2772          Attempt to release memory. We ignore MORECORE return value,
//                        2773          and instead call again to find out where new end of memory is.
//                        2774          This avoids problems if first call releases less than we asked,
//                        2775          of if failure somehow altered brk value. (We could still
//                        2776          encounter problems if it altered brk in some very bad way,
//                        2777          but the only thing we can do is adjust anyway, which will cause
//                        2778          some downstream failure.)
//                        2779        */
//            2780
//            2781       MORECORE (-extra);
//            2782       /* Call the `morecore' hook if necessary.  */
//            2783       void (*hook) (void) = atomic_forced_read (__after_morecore_hook);
//            2784       if (__builtin_expect (hook != NULL, 0))
//                2785         (*hook)();
//            2786       new_brk = (char *) (MORECORE (0));
//            2787
//            2788       LIBC_PROBE (memory_sbrk_less, 2, new_brk, extra);
//            2789
//            2790       if (new_brk != (char *) MORECORE_FAILURE)
//                2791         {
//                    2792           released = (long) (current_brk - new_brk);
//                    2793
//                    2794           if (released != 0)
//                        2795             {
//                            2796               /* Success. Adjust top. */
//                            2797               av->system_mem -= released;
//                            2798               set_head (av->top, (top_size - released) | PREV_INUSE);
//                            2799               check_malloc_state (av);
//                            2800               return 1;
//                            2801             }
//                    2802         }
//            2803     }
//    2804   return 0;
//    2805 }
//2806
//2807 static void
//2808 munmap_chunk (mchunkptr p)
//2809 {
//    2810   size_t pagesize = GLRO (dl_pagesize);
//    2811   INTERNAL_SIZE_T size = chunksize (p);
//    2812
//    2813   assert (chunk_is_mmapped (p));
//    2814
//    2815   /* Do nothing if the chunk is a faked mmapped chunk in the dumped
//            2816      main arena.  We never free this memory.  */
//    2817   if (DUMPED_MAIN_ARENA_CHUNK (p))
//        2818     return;
//    2819
//    2820   uintptr_t mem = (uintptr_t) chunk2mem (p);
//    2821   uintptr_t block = (uintptr_t) p - prev_size (p);
//    2822   size_t total_size = prev_size (p) + size;
//    2823   /* Unfortunately we have to do the compilers job by hand here.  Normally
//            2824      we would test BLOCK and TOTAL-SIZE separately for compliance with the
//            2825      page size.  But gcc does not recognize the optimization possibility
//            2826      (in the moment at least) so we combine the two values into one before
//            2827      the bit test.  */
//    2828   if (__glibc_unlikely ((block | total_size) & (pagesize - 1)) != 0
//               2829       || __glibc_unlikely (!powerof2 (mem & (pagesize - 1))))
//        2830     malloc_printerr ("munmap_chunk(): invalid pointer");
//        2831
//        2832   atomic_decrement (&mp_.n_mmaps);
//        2833   atomic_add (&mp_.mmapped_mem, -total_size);
//        2834
//        2835   /* If munmap failed the process virtual memory address space is in a
//                2836      bad shape.  Just leave the block hanging around, the process will
//                2837      terminate shortly anyway since not much can be done.  */
//        2838   __munmap ((char *) block, total_size);
//        2839 }
//2840
//2841 #if HAVE_MREMAP
//2842
//2843 static mchunkptr
//2844 mremap_chunk (mchunkptr p, size_t new_size)
//2845 {
//    2846   size_t pagesize = GLRO (dl_pagesize);
//    2847   INTERNAL_SIZE_T offset = prev_size (p);
//    2848   INTERNAL_SIZE_T size = chunksize (p);
//    2849   char *cp;
//    2850
//    2851   assert (chunk_is_mmapped (p));
//    2852
//    2853   uintptr_t block = (uintptr_t) p - offset;
//    2854   uintptr_t mem = (uintptr_t) chunk2mem(p);
//    2855   size_t total_size = offset + size;
//    2856   if (__glibc_unlikely ((block | total_size) & (pagesize - 1)) != 0
//               2857       || __glibc_unlikely (!powerof2 (mem & (pagesize - 1))))
//        2858     malloc_printerr("mremap_chunk(): invalid pointer");
//        2859
//        2860   /* Note the extra SIZE_SZ overhead as in mmap_chunk(). */
//        2861   new_size = ALIGN_UP (new_size + offset + SIZE_SZ, pagesize);
//        2862
//        2863   /* No need to remap if the number of pages does not change.  */
//        2864   if (total_size == new_size)
//            2865     return p;
//    2866
//    2867   cp = (char *) __mremap ((char *) block, total_size, new_size,
//                                   2868                           MREMAP_MAYMOVE);
//    2869
//    2870   if (cp == MAP_FAILED)
//        2871     return 0;
//    2872
//    2873   p = (mchunkptr) (cp + offset);
//    2874
//    2875   assert (aligned_OK (chunk2mem (p)));
//    2876
//    2877   assert (prev_size (p) == offset);
//    2878   set_head (p, (new_size - offset) | IS_MMAPPED);
//    2879
//    2880   INTERNAL_SIZE_T new;
//    2881   new = atomic_exchange_and_add (&mp_.mmapped_mem, new_size - size - offset)
//    2882         + new_size - size - offset;
//    2883   atomic_max (&mp_.max_mmapped_mem, new);
//    2884   return p;
//    2885 }
//2886 #endif /* HAVE_MREMAP */
//2887
//2888 /*------------------------ Public wrappers. --------------------------------*/
//2889
//2890 #if USE_TCACHE
//2891
//2892 /* We overlay this structure on the user-data portion of a chunk when
//      2893    the chunk is stored in the per-thread cache.  */
//2894 typedef struct tcache_entry
//2895 {
//    2896   struct tcache_entry *next;
//    2897   /* This field exists to detect double frees.  */
//    2898   struct tcache_perthread_struct *key;
//    2899 } tcache_entry;
//2900
//2901 /* There is one of these for each thread, which contains the
//      2902    per-thread cache (hence "tcache_perthread_struct").  Keeping
//      2903    overall size low is mildly important.  Note that COUNTS and ENTRIES
//      2904    are redundant (we could have just counted the linked list each
//      2905    time), this is for performance reasons.  */
//2906 typedef struct tcache_perthread_struct
//2907 {
//    2908   uint16_t counts[TCACHE_MAX_BINS];
//    2909   tcache_entry *entries[TCACHE_MAX_BINS];
//    2910 } tcache_perthread_struct;
//2911
//2912 static __thread bool tcache_shutting_down = false;
//2913 static __thread tcache_perthread_struct *tcache = NULL;
//2914
//2915 /* Caller must ensure that we know tc_idx is valid and there's room
//      2916    for more chunks.  */
//2917 static __always_inline void
//2918 tcache_put (mchunkptr chunk, size_t tc_idx)
//2919 {
//    2920   tcache_entry *e = (tcache_entry *) chunk2mem (chunk);
//    2921
//    2922   /* Mark this chunk as "in the tcache" so the test in _int_free will
//            2923      detect a double free.  */
//    2924   e->key = tcache;
//    2925
//    2926   e->next = tcache->entries[tc_idx];
//    2927   tcache->entries[tc_idx] = e;
//    2928   ++(tcache->counts[tc_idx]);
//    2929 }
//2930
//2931 /* Caller must ensure that we know tc_idx is valid and there's
//      2932    available chunks to remove.  */
//2933 static __always_inline void *
//2934 tcache_get (size_t tc_idx)
//2935 {
//    2936   tcache_entry *e = tcache->entries[tc_idx];
//    2937   tcache->entries[tc_idx] = e->next;
//    2938   --(tcache->counts[tc_idx]);
//    2939   e->key = NULL;
//    2940   return (void *) e;
//    2941 }
//2942
//2943 static void
//2944 tcache_thread_shutdown (void)
//2945 {
//    2946   int i;
//    2947   tcache_perthread_struct *tcache_tmp = tcache;
//    2948
//    2949   if (!tcache)
//        2950     return;
//    2951
//    2952   /* Disable the tcache and prevent it from being reinitialized.  */
//    2953   tcache = NULL;
//    2954   tcache_shutting_down = true;
//    2955
//    2956   /* Free all of the entries and the tcache itself back to the arena
//            2957      heap for coalescing.  */
//    2958   for (i = 0; i < TCACHE_MAX_BINS; ++i)
//        2959     {
//            2960       while (tcache_tmp->entries[i])
//                2961         {
//                    2962           tcache_entry *e = tcache_tmp->entries[i];
//                    2963           tcache_tmp->entries[i] = e->next;
//                    2964           __libc_free (e);
//                    2965         }
//            2966     }
//    2967
//    2968   __libc_free (tcache_tmp);
//    2969 }
//2970
//2971 static void
//2972 tcache_init(void)
//2973 {
//    2974   mstate ar_ptr;
//    2975   void *victim = 0;
//    2976   const size_t bytes = sizeof (tcache_perthread_struct);
//    2977
//    2978   if (tcache_shutting_down)
//        2979     return;
//    2980
//    2981   arena_get (ar_ptr, bytes);
//    2982   victim = _int_malloc (ar_ptr, bytes);
//    2983   if (!victim && ar_ptr != NULL)
//        2984     {
//            2985       ar_ptr = arena_get_retry (ar_ptr, bytes);
//            2986       victim = _int_malloc (ar_ptr, bytes);
//            2987     }
//    2988
//    2989
//    2990   if (ar_ptr != NULL)
//        2991     __libc_lock_unlock (ar_ptr->mutex);
//        2992
//        2993   /* In a low memory situation, we may not be able to allocate memory
//                2994      - in which case, we just keep trying later.  However, we
//                2995      typically do this very early, so either there is sufficient
//                2996      memory, or there isn't enough memory to do non-trivial
//                2997      allocations anyway.  */
//        2998   if (victim)
//            2999     {
//                3000       tcache = (tcache_perthread_struct *) victim;
//                3001       memset (tcache, 0, sizeof (tcache_perthread_struct));
//                3002     }
//    3003
//    3004 }
//3005
//3006 # define MAYBE_INIT_TCACHE() \
//3007   if (__glibc_unlikely (tcache == NULL)) \
//3008     tcache_init();
//3009
//3010 #else  /* !USE_TCACHE */
//3011 # define MAYBE_INIT_TCACHE()
//3012
//3013 static void
//3014 tcache_thread_shutdown (void)
//3015 {
//    3016   /* Nothing to do if there is no thread cache.  */
//    3017 }
//3018
//3019 #endif /* !USE_TCACHE  */
//3020
//3021 void *
//3022 __libc_malloc (size_t bytes)
//3023 {
//    3024   mstate ar_ptr;
//    3025   void *victim;
//    3026
//    3027   _Static_assert (PTRDIFF_MAX <= SIZE_MAX / 2,
//                           3028                   "PTRDIFF_MAX is not more than half of SIZE_MAX");
//    3029
//    3030   void *(*hook) (size_t, const void *)
//    3031     = atomic_forced_read (__malloc_hook);
//    3032   if (__builtin_expect (hook != NULL, 0))
//        3033     return (*hook)(bytes, RETURN_ADDRESS (0));
//    3034 #if USE_TCACHE
//        3035   /* int_free also calls request2size, be careful to not pad twice.  */
//        3036   size_t tbytes;
//    3037   if (!checked_request2size (bytes, &tbytes))
//        3038     {
//            3039       __set_errno (ENOMEM);
//            3040       return NULL;
//            3041     }
//    3042   size_t tc_idx = csize2tidx (tbytes);
//    3043
//    3044   MAYBE_INIT_TCACHE ();
//    3045
//    3046   DIAG_PUSH_NEEDS_COMMENT;
//    3047   if (tc_idx < mp_.tcache_bins
//               3048       && tcache
//               3049       && tcache->counts[tc_idx] > 0)
//        3050     {
//            3051       return tcache_get (tc_idx);
//            3052     }
//    3053   DIAG_POP_NEEDS_COMMENT;
//    3054 #endif
//    3055
//    3056   if (SINGLE_THREAD_P)
//        3057     {
//            3058       victim = _int_malloc (&main_arena, bytes);
//            3059       assert (!victim || chunk_is_mmapped (mem2chunk (victim)) ||
//                               3060               &main_arena == arena_for_chunk (mem2chunk (victim)));
//            3061       return victim;
//            3062     }
//    3063
//    3064   arena_get (ar_ptr, bytes);
//    3065
//    3066   victim = _int_malloc (ar_ptr, bytes);
//    3067   /* Retry with another arena only if we were able to find a usable arena
//            3068      before.  */
//    3069   if (!victim && ar_ptr != NULL)
//        3070     {
//            3071       LIBC_PROBE (memory_malloc_retry, 1, bytes);
//            3072       ar_ptr = arena_get_retry (ar_ptr, bytes);
//            3073       victim = _int_malloc (ar_ptr, bytes);
//            3074     }
//    3075
//    3076   if (ar_ptr != NULL)
//        3077     __libc_lock_unlock (ar_ptr->mutex);
//        3078
//        3079   assert (!victim || chunk_is_mmapped (mem2chunk (victim)) ||
//                       3080           ar_ptr == arena_for_chunk (mem2chunk (victim)));
//        3081   return victim;
//    3082 }
//3083 libc_hidden_def (__libc_malloc)
//3084
//3085 void
//3086 __libc_free (void *mem)
//3087 {
//    3088   mstate ar_ptr;
//    3089   mchunkptr p;                          /* chunk corresponding to mem */
//    3090
//    3091   void (*hook) (void *, const void *)
//    3092     = atomic_forced_read (__free_hook);
//    3093   if (__builtin_expect (hook != NULL, 0))
//        3094     {
//            3095       (*hook)(mem, RETURN_ADDRESS (0));
//            3096       return;
//            3097     }
//    3098
//    3099   if (mem == 0)                              /* free(0) has no effect */
//        3100     return;
//    3101
//    3102   p = mem2chunk (mem);
//    3103
//    3104   if (chunk_is_mmapped (p))                       /* release mmapped memory. */
//        3105     {
//            3106       /* See if the dynamic brk/mmap threshold needs adjusting.
//                        3107          Dumped fake mmapped chunks do not affect the threshold.  */
//            3108       if (!mp_.no_dyn_threshold
//                           3109           && chunksize_nomask (p) > mp_.mmap_threshold
//                           3110           && chunksize_nomask (p) <= DEFAULT_MMAP_THRESHOLD_MAX
//                           3111           && !DUMPED_MAIN_ARENA_CHUNK (p))
//                3112         {
//                    3113           mp_.mmap_threshold = chunksize (p);
//                    3114           mp_.trim_threshold = 2 * mp_.mmap_threshold;
//                    3115           LIBC_PROBE (memory_mallopt_free_dyn_thresholds, 2,
//                                               3116                       mp_.mmap_threshold, mp_.trim_threshold);
//                    3117         }
//            3118       munmap_chunk (p);
//            3119       return;
//            3120     }
//    3121
//    3122   MAYBE_INIT_TCACHE ();
//    3123
//    3124   ar_ptr = arena_for_chunk (p);
//    3125   _int_free (ar_ptr, p, 0);
//    3126 }
//3127 libc_hidden_def (__libc_free)
//3128
//3129 void *
//3130 __libc_realloc (void *oldmem, size_t bytes)
//3131 {
//    3132   mstate ar_ptr;
//    3133   INTERNAL_SIZE_T nb;         /* padded request size */
//    3134
//    3135   void *newp;             /* chunk to return */
//    3136
//    3137   void *(*hook) (void *, size_t, const void *) =
//    3138     atomic_forced_read (__realloc_hook);
//    3139   if (__builtin_expect (hook != NULL, 0))
//        3140     return (*hook)(oldmem, bytes, RETURN_ADDRESS (0));
//    3141
//    3142 #if REALLOC_ZERO_BYTES_FREES
//        3143   if (bytes == 0 && oldmem != NULL)
//            3144     {
//                3145       __libc_free (oldmem); return 0;
//                3146     }
//    3147 #endif
//    3148
//    3149   /* realloc of null is supposed to be same as malloc */
//    3150   if (oldmem == 0)
//        3151     return __libc_malloc (bytes);
//        3152
//        3153   /* chunk corresponding to oldmem */
//        3154   const mchunkptr oldp = mem2chunk (oldmem);
//        3155   /* its size */
//        3156   const INTERNAL_SIZE_T oldsize = chunksize (oldp);
//        3157
//        3158   if (chunk_is_mmapped (oldp))
//            3159     ar_ptr = NULL;
//            3160   else
//                3161     {
//                    3162       MAYBE_INIT_TCACHE ();
//                    3163       ar_ptr = arena_for_chunk (oldp);
//                    3164     }
//    3165
//    3166   /* Little security check which won't hurt performance: the allocator
//            3167      never wrapps around at the end of the address space.  Therefore
//            3168      we can exclude some size values which might appear here by
//            3169      accident or by "design" from some intruder.  We need to bypass
//            3170      this check for dumped fake mmap chunks from the old main arena
//            3171      because the new malloc may provide additional alignment.  */
//    3172   if ((__builtin_expect ((uintptr_t) oldp > (uintptr_t) -oldsize, 0)
//                3173        || __builtin_expect (misaligned_chunk (oldp), 0))
//               3174       && !DUMPED_MAIN_ARENA_CHUNK (oldp))
//        3175       malloc_printerr ("realloc(): invalid pointer");
//        3176
//        3177   if (!checked_request2size (bytes, &nb))
//            3178     {
//                3179       __set_errno (ENOMEM);
//                3180       return NULL;
//                3181     }
//    3182
//    3183   if (chunk_is_mmapped (oldp))
//        3184     {
//            3185       /* If this is a faked mmapped chunk from the dumped main arena,
//                        3186          always make a copy (and do not free the old chunk).  */
//            3187       if (DUMPED_MAIN_ARENA_CHUNK (oldp))
//                3188         {
//                    3189           /* Must alloc, copy, free. */
//                    3190           void *newmem = __libc_malloc (bytes);
//                    3191           if (newmem == 0)
//                        3192             return NULL;
//                    3193           /* Copy as many bytes as are available from the old chunk
//                                    3194              and fit into the new size.  NB: The overhead for faked
//                                    3195              mmapped chunks is only SIZE_SZ, not 2 * SIZE_SZ as for
//                                    3196              regular mmapped chunks.  */
//                    3197           if (bytes > oldsize - SIZE_SZ)
//                        3198             bytes = oldsize - SIZE_SZ;
//                    3199           memcpy (newmem, oldmem, bytes);
//                    3200           return newmem;
//                    3201         }
//            3202
//            3203       void *newmem;
//            3204
//            3205 #if HAVE_MREMAP
//                3206       newp = mremap_chunk (oldp, nb);
//            3207       if (newp)
//                3208         return chunk2mem (newp);
//            3209 #endif
//            3210       /* Note the extra SIZE_SZ overhead. */
//            3211       if (oldsize - SIZE_SZ >= nb)
//                3212         return oldmem;                         /* do nothing */
//            3213
//            3214       /* Must alloc, copy, free. */
//            3215       newmem = __libc_malloc (bytes);
//            3216       if (newmem == 0)
//                3217         return 0;              /* propagate failure */
//            3218
//            3219       memcpy (newmem, oldmem, oldsize - 2 * SIZE_SZ);
//            3220       munmap_chunk (oldp);
//            3221       return newmem;
//            3222     }
//    3223
//    3224   if (SINGLE_THREAD_P)
//        3225     {
//            3226       newp = _int_realloc (ar_ptr, oldp, oldsize, nb);
//            3227       assert (!newp || chunk_is_mmapped (mem2chunk (newp)) ||
//                               3228               ar_ptr == arena_for_chunk (mem2chunk (newp)));
//            3229
//            3230       return newp;
//            3231     }
//    3232
//    3233   __libc_lock_lock (ar_ptr->mutex);
//    3234
//    3235   newp = _int_realloc (ar_ptr, oldp, oldsize, nb);
//    3236
//    3237   __libc_lock_unlock (ar_ptr->mutex);
//    3238   assert (!newp || chunk_is_mmapped (mem2chunk (newp)) ||
//                   3239           ar_ptr == arena_for_chunk (mem2chunk (newp)));
//    3240
//    3241   if (newp == NULL)
//        3242     {
//            3243       /* Try harder to allocate memory in other arenas.  */
//            3244       LIBC_PROBE (memory_realloc_retry, 2, bytes, oldmem);
//            3245       newp = __libc_malloc (bytes);
//            3246       if (newp != NULL)
//                3247         {
//                    3248           memcpy (newp, oldmem, oldsize - SIZE_SZ);
//                    3249           _int_free (ar_ptr, oldp, 0);
//                    3250         }
//            3251     }
//    3252
//    3253   return newp;
//    3254 }
//3255 libc_hidden_def (__libc_realloc)
//3256
//3257 void *
//3258 __libc_memalign (size_t alignment, size_t bytes)
//3259 {
//    3260   void *address = RETURN_ADDRESS (0);
//    3261   return _mid_memalign (alignment, bytes, address);
//    3262 }
//3263
//3264 static void *
//3265 _mid_memalign (size_t alignment, size_t bytes, void *address)
//3266 {
//    3267   mstate ar_ptr;
//    3268   void *p;
//    3269
//    3270   void *(*hook) (size_t, size_t, const void *) =
//    3271     atomic_forced_read (__memalign_hook);
//    3272   if (__builtin_expect (hook != NULL, 0))
//        3273     return (*hook)(alignment, bytes, address);
//    3274
//    3275   /* If we need less alignment than we give anyway, just relay to malloc.  */
//    3276   if (alignment <= MALLOC_ALIGNMENT)
//        3277     return __libc_malloc (bytes);
//        3278
//        3279   /* Otherwise, ensure that it is at least a minimum chunk size */
//        3280   if (alignment < MINSIZE)
//            3281     alignment = MINSIZE;
//            3282
//            3283   /* If the alignment is greater than SIZE_MAX / 2 + 1 it cannot be a
//                    3284      power of 2 and will cause overflow in the check below.  */
//            3285   if (alignment > SIZE_MAX / 2 + 1)
//                3286     {
//                    3287       __set_errno (EINVAL);
//                    3288       return 0;
//                    3289     }
//    3290
//    3291
//    3292   /* Make sure alignment is power of 2.  */
//    3293   if (!powerof2 (alignment))
//        3294     {
//            3295       size_t a = MALLOC_ALIGNMENT * 2;
//            3296       while (a < alignment)
//                3297         a <<= 1;
//            3298       alignment = a;
//            3299     }
//    3300
//    3301   if (SINGLE_THREAD_P)
//        3302     {
//            3303       p = _int_memalign (&main_arena, alignment, bytes);
//            3304       assert (!p || chunk_is_mmapped (mem2chunk (p)) ||
//                               3305               &main_arena == arena_for_chunk (mem2chunk (p)));
//            3306
//            3307       return p;
//            3308     }
//    3309
//    3310   arena_get (ar_ptr, bytes + alignment + MINSIZE);
//    3311
//    3312   p = _int_memalign (ar_ptr, alignment, bytes);
//    3313   if (!p && ar_ptr != NULL)
//        3314     {
//            3315       LIBC_PROBE (memory_memalign_retry, 2, bytes, alignment);
//            3316       ar_ptr = arena_get_retry (ar_ptr, bytes);
//            3317       p = _int_memalign (ar_ptr, alignment, bytes);
//            3318     }
//    3319
//    3320   if (ar_ptr != NULL)
//        3321     __libc_lock_unlock (ar_ptr->mutex);
//        3322
//        3323   assert (!p || chunk_is_mmapped (mem2chunk (p)) ||
//                       3324           ar_ptr == arena_for_chunk (mem2chunk (p)));
//        3325   return p;
//    3326 }
//3327 /* For ISO C11.  */
//3328 weak_alias (__libc_memalign, aligned_alloc)
//3329 libc_hidden_def (__libc_memalign)
//3330
//3331 void *
//3332 __libc_valloc (size_t bytes)
//3333 {
//    3334   if (__malloc_initialized < 0)
//        3335     ptmalloc_init ();
//        3336
//        3337   void *address = RETURN_ADDRESS (0);
//        3338   size_t pagesize = GLRO (dl_pagesize);
//        3339   return _mid_memalign (pagesize, bytes, address);
//        3340 }
//3341
//3342 void *
//3343 __libc_pvalloc (size_t bytes)
//3344 {
//    3345   if (__malloc_initialized < 0)
//        3346     ptmalloc_init ();
//        3347
//        3348   void *address = RETURN_ADDRESS (0);
//        3349   size_t pagesize = GLRO (dl_pagesize);
//        3350   size_t rounded_bytes;
//    3351   /* ALIGN_UP with overflow check.  */
//    3352   if (__glibc_unlikely (__builtin_add_overflow (bytes,
//                                                         3353                                                 pagesize - 1,
//                                                         3354                                                 &rounded_bytes)))
//        3355     {
//            3356       __set_errno (ENOMEM);
//            3357       return 0;
//            3358     }
//    3359   rounded_bytes = rounded_bytes & -(pagesize - 1);
//    3360
//    3361   return _mid_memalign (pagesize, rounded_bytes, address);
//    3362 }
//3363
//3364 void *
//3365 __libc_calloc (size_t n, size_t elem_size)
//3366 {
//    3367   mstate av;
//    3368   mchunkptr oldtop, p;
//    3369   INTERNAL_SIZE_T sz, csz, oldtopsize;
//    3370   void *mem;
//    3371   unsigned long clearsize;
//    3372   unsigned long nclears;
//    3373   INTERNAL_SIZE_T *d;
//    3374   ptrdiff_t bytes;
//    3375
//    3376   if (__glibc_unlikely (__builtin_mul_overflow (n, elem_size, &bytes)))
//        3377     {
//            3378        __set_errno (ENOMEM);
//            3379        return NULL;
//            3380     }
//    3381   sz = bytes;
//    3382
//    3383   void *(*hook) (size_t, const void *) =
//    3384     atomic_forced_read (__malloc_hook);
//    3385   if (__builtin_expect (hook != NULL, 0))
//        3386     {
//            3387       mem = (*hook)(sz, RETURN_ADDRESS (0));
//            3388       if (mem == 0)
//                3389         return 0;
//            3390
//            3391       return memset (mem, 0, sz);
//            3392     }
//    3393
//    3394   MAYBE_INIT_TCACHE ();
//    3395
//    3396   if (SINGLE_THREAD_P)
//        3397     av = &main_arena;
//        3398   else
//            3399     arena_get (av, sz);
//            3400
//            3401   if (av)
//                3402     {
//                    3403       /* Check if we hand out the top chunk, in which case there may be no
//                                3404          need to clear. */
//                    3405 #if MORECORE_CLEARS
//                        3406       oldtop = top (av);
//                    3407       oldtopsize = chunksize (top (av));
//                    3408 # if MORECORE_CLEARS < 2
//                        3409       /* Only newly allocated memory is guaranteed to be cleared.  */
//                        3410       if (av == &main_arena &&
//                                       3411           oldtopsize < mp_.sbrk_base + av->max_system_mem - (char *) oldtop)
//                            3412         oldtopsize = (mp_.sbrk_base + av->max_system_mem - (char *) oldtop);
//                    3413 # endif
//                    3414       if (av != &main_arena)
//                        3415         {
//                            3416           heap_info *heap = heap_for_ptr (oldtop);
//                            3417           if (oldtopsize < (char *) heap + heap->mprotect_size - (char *) oldtop)
//                                3418             oldtopsize = (char *) heap + heap->mprotect_size - (char *) oldtop;
//                            3419         }
//                    3420 #endif
//                    3421     }
//    3422   else
//        3423     {
//            3424       /* No usable arenas.  */
//            3425       oldtop = 0;
//            3426       oldtopsize = 0;
//            3427     }
//    3428   mem = _int_malloc (av, sz);
//    3429
//    3430   assert (!mem || chunk_is_mmapped (mem2chunk (mem)) ||
//                   3431           av == arena_for_chunk (mem2chunk (mem)));
//    3432
//    3433   if (!SINGLE_THREAD_P)
//        3434     {
//            3435       if (mem == 0 && av != NULL)
//                3436         {
//                    3437           LIBC_PROBE (memory_calloc_retry, 1, sz);
//                    3438           av = arena_get_retry (av, sz);
//                    3439           mem = _int_malloc (av, sz);
//                    3440         }
//            3441
//            3442       if (av != NULL)
//                3443         __libc_lock_unlock (av->mutex);
//            3444     }
//    3445
//    3446   /* Allocation failed even after a retry.  */
//    3447   if (mem == 0)
//        3448     return 0;
//    3449
//    3450   p = mem2chunk (mem);
//    3451
//    3452   /* Two optional cases in which clearing not necessary */
//    3453   if (chunk_is_mmapped (p))
//        3454     {
//            3455       if (__builtin_expect (perturb_byte, 0))
//                3456         return memset (mem, 0, sz);
//            3457
//            3458       return mem;
//            3459     }
//    3460
//    3461   csz = chunksize (p);
//    3462
//    3463 #if MORECORE_CLEARS
//        3464   if (perturb_byte == 0 && (p == oldtop && csz > oldtopsize))
//            3465     {
//                3466       /* clear only the bytes from non-freshly-sbrked memory */
//                3467       csz = oldtopsize;
//                3468     }
//    3469 #endif
//    3470
//    3471   /* Unroll clear of <= 36 bytes (72 if 8byte sizes).  We know that
//            3472      contents have an odd number of INTERNAL_SIZE_T-sized words;
//            3473      minimally 3.  */
//    3474   d = (INTERNAL_SIZE_T *) mem;
//    3475   clearsize = csz - SIZE_SZ;
//    3476   nclears = clearsize / sizeof (INTERNAL_SIZE_T);
//    3477   assert (nclears >= 3);
//    3478
//    3479   if (nclears > 9)
//        3480     return memset (d, 0, clearsize);
//        3481
//        3482   else
//            3483     {
//                3484       *(d + 0) = 0;
//                3485       *(d + 1) = 0;
//                3486       *(d + 2) = 0;
//                3487       if (nclears > 4)
//                    3488         {
//                        3489           *(d + 3) = 0;
//                        3490           *(d + 4) = 0;
//                        3491           if (nclears > 6)
//                            3492             {
//                                3493               *(d + 5) = 0;
//                                3494               *(d + 6) = 0;
//                                3495               if (nclears > 8)
//                                    3496                 {
//                                        3497                   *(d + 7) = 0;
//                                        3498                   *(d + 8) = 0;
//                                        3499                 }
//                                3500             }
//                        3501         }
//                3502     }
//    3503
//    3504   return mem;
//    3505 }
//3506
//3507 /*
//      3508    ------------------------------ malloc ------------------------------
//      3509  */
//3510
//3511 static void *
//3512 _int_malloc (mstate av, size_t bytes)
//3513 {
//    3514   INTERNAL_SIZE_T nb;               /* normalized request size */
//    3515   unsigned int idx;                 /* associated bin index */
//    3516   mbinptr bin;                      /* associated bin */
//    3517
//    3518   mchunkptr victim;                 /* inspected/selected chunk */
//    3519   INTERNAL_SIZE_T size;             /* its size */
//    3520   int victim_index;                 /* its bin index */
//    3521
//    3522   mchunkptr remainder;              /* remainder from a split */
//    3523   unsigned long remainder_size;     /* its size */
//    3524
//    3525   unsigned int block;               /* bit map traverser */
//    3526   unsigned int bit;                 /* bit map traverser */
//    3527   unsigned int map;                 /* current word of binmap */
//    3528
//    3529   mchunkptr fwd;                    /* misc temp for linking */
//    3530   mchunkptr bck;                    /* misc temp for linking */
//    3531
//    3532 #if USE_TCACHE
//        3533   size_t tcache_unsorted_count;     /* count of unsorted chunks processed */
//    3534 #endif
//    3535
//    3536   /*
//            3537      Convert request size to internal form by adding SIZE_SZ bytes
//            3538      overhead plus possibly more to obtain necessary alignment and/or
//            3539      to obtain a size of at least MINSIZE, the smallest allocatable
//            3540      size. Also, checked_request2size returns false for request sizes
//            3541      that are so large that they wrap around zero when padded and
//            3542      aligned.
//            3543    */
//    3544
//    3545   if (!checked_request2size (bytes, &nb))
//        3546     {
//            3547       __set_errno (ENOMEM);
//            3548       return NULL;
//            3549     }
//    3550
//    3551   /* There are no usable arenas.  Fall back to sysmalloc to get a chunk from
//            3552      mmap.  */
//    3553   if (__glibc_unlikely (av == NULL))
//        3554     {
//            3555       void *p = sysmalloc (nb, av);
//            3556       if (p != NULL)
//                3557         alloc_perturb (p, bytes);
//            3558       return p;
//            3559     }
//    3560
//    3561   /*
//            3562      If the size qualifies as a fastbin, first check corresponding bin.
//            3563      This code is safe to execute even if av is not yet initialized, so we
//            3564      can try it without checking, which saves some time on this fast path.
//            3565    */
//    3566
//    3567 #define REMOVE_FB(fb, victim, pp)                       \
//    3568   do                                                    \
//        3569     {                                                   \
//            3570       victim = pp;                                      \
//            3571       if (victim == NULL)                               \
//                3572         break;                                          \
//            3573     }                                                   \
//    3574   while ((pp = catomic_compare_and_exchange_val_acq (fb, victim->fd, victim)) \
//                  3575          != victim);                                    \
//    3576
//    3577   if ((unsigned long) (nb) <= (unsigned long) (get_max_fast ()))
//        3578     {
//            3579       idx = fastbin_index (nb);
//            3580       mfastbinptr *fb = &fastbin (av, idx);
//            3581       mchunkptr pp;
//            3582       victim = *fb;
//            3583
//            3584       if (victim != NULL)
//                3585         {
//                    3586           if (SINGLE_THREAD_P)
//                        3587             *fb = victim->fd;
//                    3588           else
//                        3589             REMOVE_FB (fb, pp, victim);
//                    3590           if (__glibc_likely (victim != NULL))
//                        3591             {
//                            3592               size_t victim_idx = fastbin_index (chunksize (victim));
//                            3593               if (__builtin_expect (victim_idx != idx, 0))
//                                3594                 malloc_printerr ("malloc(): memory corruption (fast)");
//                            3595               check_remalloced_chunk (av, victim, nb);
//                            3596 #if USE_TCACHE
//                                3597               /* While we're here, if we see other chunks of the same size,
//                                                    3598                  stash them in the tcache.  */
//                                3599               size_t tc_idx = csize2tidx (nb);
//                            3600               if (tcache && tc_idx < mp_.tcache_bins)
//                                3601                 {
//                                    3602                   mchunkptr tc_victim;
//                                    3603
//                                    3604                   /* While bin not empty and tcache not full, copy chunks.  */
//                                    3605                   while (tcache->counts[tc_idx] < mp_.tcache_count
//                                                                  3606                          && (tc_victim = *fb) != NULL)
//                                        3607                     {
//                                            3608                       if (SINGLE_THREAD_P)
//                                                3609                         *fb = tc_victim->fd;
//                                            3610                       else
//                                                3611                         {
//                                                    3612                           REMOVE_FB (fb, pp, tc_victim);
//                                                    3613                           if (__glibc_unlikely (tc_victim == NULL))
//                                                        3614                             break;
//                                                    3615                         }
//                                            3616                       tcache_put (tc_victim, tc_idx);
//                                            3617                     }
//                                    3618                 }
//                            3619 #endif
//                            3620               void *p = chunk2mem (victim);
//                            3621               alloc_perturb (p, bytes);
//                            3622               return p;
//                            3623             }
//                    3624         }
//            3625     }
//    3626
//    3627   /*
//            3628      If a small request, check regular bin.  Since these "smallbins"
//            3629      hold one size each, no searching within bins is necessary.
//            3630      (For a large request, we need to wait until unsorted chunks are
//            3631      processed to find best fit. But for small ones, fits are exact
//            3632      anyway, so we can check now, which is faster.)
//            3633    */
//    3634
//    3635   if (in_smallbin_range (nb))
//        3636     {
//            3637       idx = smallbin_index (nb);
//            3638       bin = bin_at (av, idx);
//            3639
//            3640       if ((victim = last (bin)) != bin)
//                3641         {
//                    3642           bck = victim->bk;
//                    3643           if (__glibc_unlikely (bck->fd != victim))
//                        3644             malloc_printerr ("malloc(): smallbin double linked list corrupted");
//                    3645           set_inuse_bit_at_offset (victim, nb);
//                    3646           bin->bk = bck;
//                    3647           bck->fd = bin;
//                    3648
//                    3649           if (av != &main_arena)
//                        3650             set_non_main_arena (victim);
//                    3651           check_malloced_chunk (av, victim, nb);
//                    3652 #if USE_TCACHE
//                        3653           /* While we're here, if we see other chunks of the same size,
//                                        3654              stash them in the tcache.  */
//                        3655           size_t tc_idx = csize2tidx (nb);
//                    3656           if (tcache && tc_idx < mp_.tcache_bins)
//                        3657             {
//                            3658               mchunkptr tc_victim;
//                            3659
//                            3660               /* While bin not empty and tcache not full, copy chunks over.  */
//                            3661               while (tcache->counts[tc_idx] < mp_.tcache_count
//                                                      3662                      && (tc_victim = last (bin)) != bin)
//                                3663                 {
//                                    3664                   if (tc_victim != 0)
//                                        3665                     {
//                                            3666                       bck = tc_victim->bk;
//                                            3667                       set_inuse_bit_at_offset (tc_victim, nb);
//                                            3668                       if (av != &main_arena)
//                                                3669                         set_non_main_arena (tc_victim);
//                                            3670                       bin->bk = bck;
//                                            3671                       bck->fd = bin;
//                                            3672
//                                            3673                       tcache_put (tc_victim, tc_idx);
//                                            3674                     }
//                                    3675                 }
//                            3676             }
//                    3677 #endif
//                    3678           void *p = chunk2mem (victim);
//                    3679           alloc_perturb (p, bytes);
//                    3680           return p;
//                    3681         }
//            3682     }
//    3683
//    3684   /*
//            3685      If this is a large request, consolidate fastbins before continuing.
//            3686      While it might look excessive to kill all fastbins before
//            3687      even seeing if there is space available, this avoids
//            3688      fragmentation problems normally associated with fastbins.
//            3689      Also, in practice, programs tend to have runs of either small or
//            3690      large requests, but less often mixtures, so consolidation is not
//            3691      invoked all that often in most programs. And the programs that
//            3692      it is called frequently in otherwise tend to fragment.
//            3693    */
//    3694
//    3695   else
//        3696     {
//            3697       idx = largebin_index (nb);
//            3698       if (atomic_load_relaxed (&av->have_fastchunks))
//                3699         malloc_consolidate (av);
//            3700     }
//    3701
//    3702   /*
//            3703      Process recently freed or remaindered chunks, taking one only if
//            3704      it is exact fit, or, if this a small request, the chunk is remainder from
//            3705      the most recent non-exact fit.  Place other traversed chunks in
//            3706      bins.  Note that this step is the only place in any routine where
//            3707      chunks are placed in bins.
//            3708
//            3709      The outer loop here is needed because we might not realize until
//            3710      near the end of malloc that we should have consolidated, so must
//            3711      do so and retry. This happens at most once, and only when we would
//            3712      otherwise need to expand memory to service a "small" request.
//            3713    */
//    3714
//    3715 #if USE_TCACHE
//        3716   INTERNAL_SIZE_T tcache_nb = 0;
//        3717   size_t tc_idx = csize2tidx (nb);
//        3718   if (tcache && tc_idx < mp_.tcache_bins)
//            3719     tcache_nb = nb;
//            3720   int return_cached = 0;
//            3721
//            3722   tcache_unsorted_count = 0;
//            3723 #endif
//            3724
//            3725   for (;; )
//                3726     {
//                    3727       int iters = 0;
//                    3728       while ((victim = unsorted_chunks (av)->bk) != unsorted_chunks (av))
//                        3729         {
//                            3730           bck = victim->bk;
//                            3731           size = chunksize (victim);
//                            3732           mchunkptr next = chunk_at_offset (victim, size);
//                            3733
//                            3734           if (__glibc_unlikely (size <= 2 * SIZE_SZ)
//                                               3735               || __glibc_unlikely (size > av->system_mem))
//                                3736             malloc_printerr ("malloc(): invalid size (unsorted)");
//                            3737           if (__glibc_unlikely (chunksize_nomask (next) < 2 * SIZE_SZ)
//                                               3738               || __glibc_unlikely (chunksize_nomask (next) > av->system_mem))
//                                3739             malloc_printerr ("malloc(): invalid next size (unsorted)");
//                            3740           if (__glibc_unlikely ((prev_size (next) & ~(SIZE_BITS)) != size))
//                                3741             malloc_printerr ("malloc(): mismatching next->prev_size (unsorted)");
//                            3742           if (__glibc_unlikely (bck->fd != victim)
//                                               3743               || __glibc_unlikely (victim->fd != unsorted_chunks (av)))
//                                3744             malloc_printerr ("malloc(): unsorted double linked list corrupted");
//                            3745           if (__glibc_unlikely (prev_inuse (next)))
//                                3746             malloc_printerr ("malloc(): invalid next->prev_inuse (unsorted)");
//                            3747
//                            3748           /*
//                                            3749              If a small request, try to use last remainder if it is the
//                                            3750              only chunk in unsorted bin.  This helps promote locality for
//                                            3751              runs of consecutive small requests. This is the only
//                                            3752              exception to best-fit, and applies only when there is
//                                            3753              no exact fit for a small chunk.
//                                            3754            */
//                            3755
//                            3756           if (in_smallbin_range (nb) &&
//                                               3757               bck == unsorted_chunks (av) &&
//                                               3758               victim == av->last_remainder &&
//                                               3759               (unsigned long) (size) > (unsigned long) (nb + MINSIZE))
//                                3760             {
//                                    3761               /* split and reattach remainder */
//                                    3762               remainder_size = size - nb;
//                                    3763               remainder = chunk_at_offset (victim, nb);
//                                    3764               unsorted_chunks (av)->bk = unsorted_chunks (av)->fd = remainder;
//                                    3765               av->last_remainder = remainder;
//                                    3766               remainder->bk = remainder->fd = unsorted_chunks (av);
//                                    3767               if (!in_smallbin_range (remainder_size))
//                                        3768                 {
//                                            3769                   remainder->fd_nextsize = NULL;
//                                            3770                   remainder->bk_nextsize = NULL;
//                                            3771                 }
//                                    3772
//                                    3773               set_head (victim, nb | PREV_INUSE |
//                                                                 3774                         (av != &main_arena ? NON_MAIN_ARENA : 0));
//                                    3775               set_head (remainder, remainder_size | PREV_INUSE);
//                                    3776               set_foot (remainder, remainder_size);
//                                    3777
//                                    3778               check_malloced_chunk (av, victim, nb);
//                                    3779               void *p = chunk2mem (victim);
//                                    3780               alloc_perturb (p, bytes);
//                                    3781               return p;
//                                    3782             }
//                            3783
//                            3784           /* remove from unsorted list */
//                            3785           if (__glibc_unlikely (bck->fd != victim))
//                                3786             malloc_printerr ("malloc(): corrupted unsorted chunks 3");
//                            3787           unsorted_chunks (av)->bk = bck;
//                            3788           bck->fd = unsorted_chunks (av);
//                            3789
//                            3790           /* Take now instead of binning if exact fit */
//                            3791
//                            3792           if (size == nb)
//                                3793             {
//                                    3794               set_inuse_bit_at_offset (victim, size);
//                                    3795               if (av != &main_arena)
//                                        3796                 set_non_main_arena (victim);
//                                    3797 #if USE_TCACHE
//                                        3798               /* Fill cache first, return to user only if cache fills.
//                                                            3799                  We may return one of these chunks later.  */
//                                        3800               if (tcache_nb
//                                                               3801                   && tcache->counts[tc_idx] < mp_.tcache_count)
//                                            3802                 {
//                                                3803                   tcache_put (victim, tc_idx);
//                                                3804                   return_cached = 1;
//                                                3805                   continue;
//                                                3806                 }
//                                    3807               else
//                                        3808                 {
//                                            3809 #endif
//                                            3810               check_malloced_chunk (av, victim, nb);
//                                            3811               void *p = chunk2mem (victim);
//                                            3812               alloc_perturb (p, bytes);
//                                            3813               return p;
//                                            3814 #if USE_TCACHE
//                                                3815                 }
//                                    3816 #endif
//                                    3817             }
//                            3818
//                            3819           /* place chunk in bin */
//                            3820
//                            3821           if (in_smallbin_range (size))
//                                3822             {
//                                    3823               victim_index = smallbin_index (size);
//                                    3824               bck = bin_at (av, victim_index);
//                                    3825               fwd = bck->fd;
//                                    3826             }
//                            3827           else
//                                3828             {
//                                    3829               victim_index = largebin_index (size);
//                                    3830               bck = bin_at (av, victim_index);
//                                    3831               fwd = bck->fd;
//                                    3832
//                                    3833               /* maintain large bins in sorted order */
//                                    3834               if (fwd != bck)
//                                        3835                 {
//                                            3836                   /* Or with inuse bit to speed comparisons */
//                                            3837                   size |= PREV_INUSE;
//                                            3838                   /* if smaller than smallest, bypass loop below */
//                                            3839                   assert (chunk_main_arena (bck->bk));
//                                            3840                   if ((unsigned long) (size)
//                                                                       3841                       < (unsigned long) chunksize_nomask (bck->bk))
//                                                3842                     {
//                                                    3843                       fwd = bck;
//                                                    3844                       bck = bck->bk;
//                                                    3845
//                                                    3846                       victim->fd_nextsize = fwd->fd;
//                                                    3847                       victim->bk_nextsize = fwd->fd->bk_nextsize;
//                                                    3848                       fwd->fd->bk_nextsize = victim->bk_nextsize->fd_nextsize = victim;
//                                                    3849                     }
//                                            3850                   else
//                                                3851                     {
//                                                    3852                       assert (chunk_main_arena (fwd));
//                                                    3853                       while ((unsigned long) size < chunksize_nomask (fwd))
//                                                        3854                         {
//                                                            3855                           fwd = fwd->fd_nextsize;
//                                                            3856                           assert (chunk_main_arena (fwd));
//                                                            3857                         }
//                                                    3858
//                                                    3859                       if ((unsigned long) size
//                                                                                   3860                           == (unsigned long) chunksize_nomask (fwd))
//                                                        3861                         /* Always insert in the second position.  */
//                                                        3862                         fwd = fwd->fd;
//                                                    3863                       else
//                                                        3864                         {
//                                                            3865                           victim->fd_nextsize = fwd;
//                                                            3866                           victim->bk_nextsize = fwd->bk_nextsize;
//                                                            3867                           if (__glibc_unlikely (fwd->bk_nextsize->fd_nextsize != fwd))
//                                                                3868                             malloc_printerr ("malloc(): largebin double linked list corrupted (nextsize)");
//                                                            3869                           fwd->bk_nextsize = victim;
//                                                            3870                           victim->bk_nextsize->fd_nextsize = victim;
//                                                            3871                         }
//                                                    3872                       bck = fwd->bk;
//                                                    3873                       if (bck->fd != fwd)
//                                                        3874                         malloc_printerr ("malloc(): largebin double linked list corrupted (bk)");
//                                                    3875                     }
//                                            3876                 }
//                                    3877               else
//                                        3878                 victim->fd_nextsize = victim->bk_nextsize = victim;
//                                    3879             }
//                            3880
//                            3881           mark_bin (av, victim_index);
//                            3882           victim->bk = bck;
//                            3883           victim->fd = fwd;
//                            3884           fwd->bk = victim;
//                            3885           bck->fd = victim;
//                            3886
//                            3887 #if USE_TCACHE
//                                3888       /* If we've processed as many chunks as we're allowed while
//                                            3889          filling the cache, return one of the cached ones.  */
//                                3890       ++tcache_unsorted_count;
//                            3891       if (return_cached
//                                           3892           && mp_.tcache_unsorted_limit > 0
//                                           3893           && tcache_unsorted_count > mp_.tcache_unsorted_limit)
//                                3894         {
//                                    3895           return tcache_get (tc_idx);
//                                    3896         }
//                            3897 #endif
//                            3898
//                            3899 #define MAX_ITERS       10000
//                            3900           if (++iters >= MAX_ITERS)
//                                3901             break;
//                            3902         }
//                    3903
//                    3904 #if USE_TCACHE
//                        3905       /* If all the small chunks we found ended up cached, return one now.  */
//                        3906       if (return_cached)
//                            3907         {
//                                3908           return tcache_get (tc_idx);
//                                3909         }
//                    3910 #endif
//                    3911
//                    3912       /*
//                                3913          If a large request, scan through the chunks of current bin in
//                                3914          sorted order to find smallest that fits.  Use the skip list for this.
//                                3915        */
//                    3916
//                    3917       if (!in_smallbin_range (nb))
//                        3918         {
//                            3919           bin = bin_at (av, idx);
//                            3920
//                            3921           /* skip scan if empty or largest chunk is too small */
//                            3922           if ((victim = first (bin)) != bin
//                                               3923               && (unsigned long) chunksize_nomask (victim)
//                                               3924                 >= (unsigned long) (nb))
//                                3925             {
//                                    3926               victim = victim->bk_nextsize;
//                                    3927               while (((unsigned long) (size = chunksize (victim)) <
//                                                               3928                       (unsigned long) (nb)))
//                                        3929                 victim = victim->bk_nextsize;
//                                    3930
//                                    3931               /* Avoid removing the first entry for a size so that the skip
//                                                        3932                  list does not have to be rerouted.  */
//                                    3933               if (victim != last (bin)
//                                                           3934                   && chunksize_nomask (victim)
//                                                           3935                     == chunksize_nomask (victim->fd))
//                                        3936                 victim = victim->fd;
//                                    3937
//                                    3938               remainder_size = size - nb;
//                                    3939               unlink_chunk (av, victim);
//                                    3940
//                                    3941               /* Exhaust */
//                                    3942               if (remainder_size < MINSIZE)
//                                        3943                 {
//                                            3944                   set_inuse_bit_at_offset (victim, size);
//                                            3945                   if (av != &main_arena)
//                                                3946                     set_non_main_arena (victim);
//                                            3947                 }
//                                    3948               /* Split */
//                                    3949               else
//                                        3950                 {
//                                            3951                   remainder = chunk_at_offset (victim, nb);
//                                            3952                   /* We cannot assume the unsorted list is empty and therefore
//                                                                    3953                      have to perform a complete insert here.  */
//                                            3954                   bck = unsorted_chunks (av);
//                                            3955                   fwd = bck->fd;
//                                            3956                   if (__glibc_unlikely (fwd->bk != bck))
//                                                3957                     malloc_printerr ("malloc(): corrupted unsorted chunks");
//                                            3958                   remainder->bk = bck;
//                                            3959                   remainder->fd = fwd;
//                                            3960                   bck->fd = remainder;
//                                            3961                   fwd->bk = remainder;
//                                            3962                   if (!in_smallbin_range (remainder_size))
//                                                3963                     {
//                                                    3964                       remainder->fd_nextsize = NULL;
//                                                    3965                       remainder->bk_nextsize = NULL;
//                                                    3966                     }
//                                            3967                   set_head (victim, nb | PREV_INUSE |
//                                                                             3968                             (av != &main_arena ? NON_MAIN_ARENA : 0));
//                                            3969                   set_head (remainder, remainder_size | PREV_INUSE);
//                                            3970                   set_foot (remainder, remainder_size);
//                                            3971                 }
//                                    3972               check_malloced_chunk (av, victim, nb);
//                                    3973               void *p = chunk2mem (victim);
//                                    3974               alloc_perturb (p, bytes);
//                                    3975               return p;
//                                    3976             }
//                            3977         }
//                    3978
//                    3979       /*
//                                3980          Search for a chunk by scanning bins, starting with next largest
//                                3981          bin. This search is strictly by best-fit; i.e., the smallest
//                                3982          (with ties going to approximately the least recently used) chunk
//                                3983          that fits is selected.
//                                3984
//                                3985          The bitmap avoids needing to check that most blocks are nonempty.
//                                3986          The particular case of skipping all bins during warm-up phases
//                                3987          when no chunks have been returned yet is faster than it might look.
//                                3988        */
//                    3989
//                    3990       ++idx;
//                    3991       bin = bin_at (av, idx);
//                    3992       block = idx2block (idx);
//                    3993       map = av->binmap[block];
//                    3994       bit = idx2bit (idx);
//                    3995
//                    3996       for (;; )
//                        3997         {
//                            3998           /* Skip rest of block if there are no more set bits in this block.  */
//                            3999           if (bit > map || bit == 0)
//                                4000             {
//                                    4001               do
//                                        4002                 {
//                                            4003                   if (++block >= BINMAPSIZE) /* out of bins */
//                                                4004                     goto use_top;
//                                            4005                 }
//                                    4006               while ((map = av->binmap[block]) == 0);
//                                    4007
//                                    4008               bin = bin_at (av, (block << BINMAPSHIFT));
//                                    4009               bit = 1;
//                                    4010             }
//                            4011
//                            4012           /* Advance to bin with set bit. There must be one. */
//                            4013           while ((bit & map) == 0)
//                                4014             {
//                                    4015               bin = next_bin (bin);
//                                    4016               bit <<= 1;
//                                    4017               assert (bit != 0);
//                                    4018             }
//                            4019
//                            4020           /* Inspect the bin. It is likely to be non-empty */
//                            4021           victim = last (bin);
//                            4022
//                            4023           /*  If a false alarm (empty bin), clear the bit. */
//                            4024           if (victim == bin)
//                                4025             {
//                                    4026               av->binmap[block] = map &= ~bit; /* Write through */
//                                    4027               bin = next_bin (bin);
//                                    4028               bit <<= 1;
//                                    4029             }
//                            4030
//                            4031           else
//                                4032             {
//                                    4033               size = chunksize (victim);
//                                    4034
//                                    4035               /*  We know the first chunk in this bin is big enough to use. */
//                                    4036               assert ((unsigned long) (size) >= (unsigned long) (nb));
//                                    4037
//                                    4038               remainder_size = size - nb;
//                                    4039
//                                    4040               /* unlink */
//                                    4041               unlink_chunk (av, victim);
//                                    4042
//                                    4043               /* Exhaust */
//                                    4044               if (remainder_size < MINSIZE)
//                                        4045                 {
//                                            4046                   set_inuse_bit_at_offset (victim, size);
//                                            4047                   if (av != &main_arena)
//                                                4048                     set_non_main_arena (victim);
//                                            4049                 }
//                                    4050
//                                    4051               /* Split */
//                                    4052               else
//                                        4053                 {
//                                            4054                   remainder = chunk_at_offset (victim, nb);
//                                            4055
//                                            4056                   /* We cannot assume the unsorted list is empty and therefore
//                                                                    4057                      have to perform a complete insert here.  */
//                                            4058                   bck = unsorted_chunks (av);
//                                            4059                   fwd = bck->fd;
//                                            4060                   if (__glibc_unlikely (fwd->bk != bck))
//                                                4061                     malloc_printerr ("malloc(): corrupted unsorted chunks 2");
//                                            4062                   remainder->bk = bck;
//                                            4063                   remainder->fd = fwd;
//                                            4064                   bck->fd = remainder;
//                                            4065                   fwd->bk = remainder;
//                                            4066
//                                            4067                   /* advertise as last remainder */
//                                            4068                   if (in_smallbin_range (nb))
//                                                4069                     av->last_remainder = remainder;
//                                            4070                   if (!in_smallbin_range (remainder_size))
//                                                4071                     {
//                                                    4072                       remainder->fd_nextsize = NULL;
//                                                    4073                       remainder->bk_nextsize = NULL;
//                                                    4074                     }
//                                            4075                   set_head (victim, nb | PREV_INUSE |
//                                                                             4076                             (av != &main_arena ? NON_MAIN_ARENA : 0));
//                                            4077                   set_head (remainder, remainder_size | PREV_INUSE);
//                                            4078                   set_foot (remainder, remainder_size);
//                                            4079                 }
//                                    4080               check_malloced_chunk (av, victim, nb);
//                                    4081               void *p = chunk2mem (victim);
//                                    4082               alloc_perturb (p, bytes);
//                                    4083               return p;
//                                    4084             }
//                            4085         }
//                    4086
//                    4087     use_top:
//                    4088       /*
//                                4089          If large enough, split off the chunk bordering the end of memory
//                                4090          (held in av->top). Note that this is in accord with the best-fit
//                                4091          search rule.  In effect, av->top is treated as larger (and thus
//                                4092          less well fitting) than any other available chunk since it can
//                                4093          be extended to be as large as necessary (up to system
//                                4094          limitations).
//                                4095
//                                4096          We require that av->top always exists (i.e., has size >=
//                                4097          MINSIZE) after initialization, so if it would otherwise be
//                                4098          exhausted by current request, it is replenished. (The main
//                                4099          reason for ensuring it exists is that we may need MINSIZE space
//                                4100          to put in fenceposts in sysmalloc.)
//                                4101        */
//                    4102
//                    4103       victim = av->top;
//                    4104       size = chunksize (victim);
//                    4105
//                    4106       if (__glibc_unlikely (size > av->system_mem))
//                        4107         malloc_printerr ("malloc(): corrupted top size");
//                    4108
//                    4109       if ((unsigned long) (size) >= (unsigned long) (nb + MINSIZE))
//                        4110         {
//                            4111           remainder_size = size - nb;
//                            4112           remainder = chunk_at_offset (victim, nb);
//                            4113           av->top = remainder;
//                            4114           set_head (victim, nb | PREV_INUSE |
//                                                     4115                     (av != &main_arena ? NON_MAIN_ARENA : 0));
//                            4116           set_head (remainder, remainder_size | PREV_INUSE);
//                            4117
//                            4118           check_malloced_chunk (av, victim, nb);
//                            4119           void *p = chunk2mem (victim);
//                            4120           alloc_perturb (p, bytes);
//                            4121           return p;
//                            4122         }
//                    4123
//                    4124       /* When we are using atomic ops to free fast chunks we can get
//                                4125          here for all block sizes.  */
//                    4126       else if (atomic_load_relaxed (&av->have_fastchunks))
//                        4127         {
//                            4128           malloc_consolidate (av);
//                            4129           /* restore original bin index */
//                            4130           if (in_smallbin_range (nb))
//                                4131             idx = smallbin_index (nb);
//                            4132           else
//                                4133             idx = largebin_index (nb);
//                            4134         }
//                    4135
//                    4136       /*
//                                4137          Otherwise, relay to handle system-dependent cases
//                                4138        */
//                    4139       else
//                        4140         {
//                            4141           void *p = sysmalloc (nb, av);
//                            4142           if (p != NULL)
//                                4143             alloc_perturb (p, bytes);
//                            4144           return p;
//                            4145         }
//                    4146     }
//    4147 }
//4148
//4149 /*
//      4150    ------------------------------ free ------------------------------
//      4151  */
//4152
//4153 static void
//4154 _int_free (mstate av, mchunkptr p, int have_lock)
//4155 {
//    4156   INTERNAL_SIZE_T size;        /* its size */
//    4157   mfastbinptr *fb;             /* associated fastbin */
//    4158   mchunkptr nextchunk;         /* next contiguous chunk */
//    4159   INTERNAL_SIZE_T nextsize;    /* its size */
//    4160   int nextinuse;               /* true if nextchunk is used */
//    4161   INTERNAL_SIZE_T prevsize;    /* size of previous contiguous chunk */
//    4162   mchunkptr bck;               /* misc temp for linking */
//    4163   mchunkptr fwd;               /* misc temp for linking */
//    4164
//    4165   size = chunksize (p);
//    4166
//    4167   /* Little security check which won't hurt performance: the
//            4168      allocator never wrapps around at the end of the address space.
//            4169      Therefore we can exclude some size values which might appear
//            4170      here by accident or by "design" from some intruder.  */
//    4171   if (__builtin_expect ((uintptr_t) p > (uintptr_t) -size, 0)
//               4172       || __builtin_expect (misaligned_chunk (p), 0))
//        4173     malloc_printerr ("free(): invalid pointer");
//        4174   /* We know that each chunk is at least MINSIZE bytes in size or a
//                4175      multiple of MALLOC_ALIGNMENT.  */
//        4176   if (__glibc_unlikely (size < MINSIZE || !aligned_OK (size)))
//            4177     malloc_printerr ("free(): invalid size");
//            4178
//            4179   check_inuse_chunk(av, p);
//            4180
//            4181 #if USE_TCACHE
//                4182   {
//                    4183     size_t tc_idx = csize2tidx (size);
//                    4184     if (tcache != NULL && tc_idx < mp_.tcache_bins)
//                        4185       {
//                            4186         /* Check to see if it's already in the tcache.  */
//                            4187         tcache_entry *e = (tcache_entry *) chunk2mem (p);
//                            4188
//                            4189         /* This test succeeds on double free.  However, we don't 100%
//                                          4190            trust it (it also matches random payload data at a 1 in
//                                          4191            2^<size_t> chance), so verify it's not an unlikely
//                                          4192            coincidence before aborting.  */
//                            4193         if (__glibc_unlikely (e->key == tcache))
//                                4194           {
//                                    4195             tcache_entry *tmp;
//                                    4196             LIBC_PROBE (memory_tcache_double_free, 2, e, tc_idx);
//                                    4197             for (tmp = tcache->entries[tc_idx];
//                                                          4198                  tmp;
//                                                          4199                  tmp = tmp->next)
//                                        4200               if (tmp == e)
//                                            4201                 malloc_printerr ("free(): double free detected in tcache 2");
//                                    4202             /* If we get here, it was a coincidence.  We've wasted a
//                                                      4203                few cycles, but don't abort.  */
//                                    4204           }
//                            4205
//                            4206         if (tcache->counts[tc_idx] < mp_.tcache_count)
//                                4207           {
//                                    4208             tcache_put (p, tc_idx);
//                                    4209             return;
//                                    4210           }
//                            4211       }
//                    4212   }
//    4213 #endif
//    4214
//    4215   /*
//            4216     If eligible, place chunk on a fastbin so it can be found
//            4217     and used quickly in malloc.
//            4218   */
//    4219
//    4220   if ((unsigned long)(size) <= (unsigned long)(get_max_fast ())
//               4221
//               4222 #if TRIM_FASTBINS
//               4223       /*
//                           4224         If TRIM_FASTBINS set, don't place chunks
//                           4225         bordering top into fastbins
//                           4226       */
//               4227       && (chunk_at_offset(p, size) != av->top)
//               4228 #endif
//               4229       ) {
//        4230
//        4231     if (__builtin_expect (chunksize_nomask (chunk_at_offset (p, size))
//                                       4232                           <= 2 * SIZE_SZ, 0)
//                     4233         || __builtin_expect (chunksize (chunk_at_offset (p, size))
//                                                       4234                              >= av->system_mem, 0))
//            4235       {
//                4236         bool fail = true;
//                4237         /* We might not have a lock at this point and concurrent modifications
//                              4238            of system_mem might result in a false positive.  Redo the test after
//                              4239            getting the lock.  */
//                4240         if (!have_lock)
//                    4241           {
//                        4242             __libc_lock_lock (av->mutex);
//                        4243             fail = (chunksize_nomask (chunk_at_offset (p, size)) <= 2 * SIZE_SZ
//                                                 4244                     || chunksize (chunk_at_offset (p, size)) >= av->system_mem);
//                        4245             __libc_lock_unlock (av->mutex);
//                        4246           }
//                4247
//                4248         if (fail)
//                    4249           malloc_printerr ("free(): invalid next size (fast)");
//                4250       }
//        4251
//        4252     free_perturb (chunk2mem(p), size - 2 * SIZE_SZ);
//        4253
//        4254     atomic_store_relaxed (&av->have_fastchunks, true);
//        4255     unsigned int idx = fastbin_index(size);
//        4256     fb = &fastbin (av, idx);
//        4257
//        4258     /* Atomically link P to its fastbin: P->FD = *FB; *FB = P;  */
//        4259     mchunkptr old = *fb, old2;
//        4260
//        4261     if (SINGLE_THREAD_P)
//            4262       {
//                4263         /* Check that the top of the bin is not the record we are going to
//                              4264            add (i.e., double free).  */
//                4265         if (__builtin_expect (old == p, 0))
//                    4266           malloc_printerr ("double free or corruption (fasttop)");
//                4267         p->fd = old;
//                4268         *fb = p;
//                4269       }
//        4270     else
//            4271       do
//                4272         {
//                    4273           /* Check that the top of the bin is not the record we are going to
//                                    4274              add (i.e., double free).  */
//                    4275           if (__builtin_expect (old == p, 0))
//                        4276             malloc_printerr ("double free or corruption (fasttop)");
//                    4277           p->fd = old2 = old;
//                    4278         }
//        4279       while ((old = catomic_compare_and_exchange_val_rel (fb, p, old2))
//                          4280              != old2);
//        4281
//        4282     /* Check that size of fastbin chunk at the top is the same as
//                  4283        size of the chunk that we are adding.  We can dereference OLD
//                  4284        only if we have the lock, otherwise it might have already been
//                  4285        allocated again.  */
//        4286     if (have_lock && old != NULL
//                     4287         && __builtin_expect (fastbin_index (chunksize (old)) != idx, 0))
//            4288       malloc_printerr ("invalid fastbin entry (free)");
//        4289   }
//    4290
//    4291   /*
//            4292     Consolidate other non-mmapped chunks as they arrive.
//            4293   */
//    4294
//    4295   else if (!chunk_is_mmapped(p)) {
//        4296
//        4297     /* If we're single-threaded, don't lock the arena.  */
//        4298     if (SINGLE_THREAD_P)
//            4299       have_lock = true;
//        4300
//        4301     if (!have_lock)
//            4302       __libc_lock_lock (av->mutex);
//        4303
//        4304     nextchunk = chunk_at_offset(p, size);
//        4305
//        4306     /* Lightweight tests: check whether the block is already the
//                  4307        top block.  */
//        4308     if (__glibc_unlikely (p == av->top))
//            4309       malloc_printerr ("double free or corruption (top)");
//        4310     /* Or whether the next chunk is beyond the boundaries of the arena.  */
//        4311     if (__builtin_expect (contiguous (av)
//                                       4312                           && (char *) nextchunk
//                                       4313                           >= ((char *) av->top + chunksize(av->top)), 0))
//            4314         malloc_printerr ("double free or corruption (out)");
//        4315     /* Or whether the block is actually not marked used.  */
//        4316     if (__glibc_unlikely (!prev_inuse(nextchunk)))
//            4317       malloc_printerr ("double free or corruption (!prev)");
//        4318
//        4319     nextsize = chunksize(nextchunk);
//        4320     if (__builtin_expect (chunksize_nomask (nextchunk) <= 2 * SIZE_SZ, 0)
//                     4321         || __builtin_expect (nextsize >= av->system_mem, 0))
//            4322       malloc_printerr ("free(): invalid next size (normal)");
//        4323
//        4324     free_perturb (chunk2mem(p), size - 2 * SIZE_SZ);
//        4325
//        4326     /* consolidate backward */
//        4327     if (!prev_inuse(p)) {
//            4328       prevsize = prev_size (p);
//            4329       size += prevsize;
//            4330       p = chunk_at_offset(p, -((long) prevsize));
//            4331       if (__glibc_unlikely (chunksize(p) != prevsize))
//                4332         malloc_printerr ("corrupted size vs. prev_size while consolidating");
//            4333       unlink_chunk (av, p);
//            4334     }
//        4335
//        4336     if (nextchunk != av->top) {
//            4337       /* get and clear inuse bit */
//            4338       nextinuse = inuse_bit_at_offset(nextchunk, nextsize);
//            4339
//            4340       /* consolidate forward */
//            4341       if (!nextinuse) {
//                4342         unlink_chunk (av, nextchunk);
//                4343         size += nextsize;
//                4344       } else
//                    4345         clear_inuse_bit_at_offset(nextchunk, 0);
//            4346
//            4347       /*
//                        4348         Place the chunk in unsorted chunk list. Chunks are
//                        4349         not placed into regular bins until after they have
//                        4350         been given one chance to be used in malloc.
//                        4351       */
//            4352
//            4353       bck = unsorted_chunks(av);
//            4354       fwd = bck->fd;
//            4355       if (__glibc_unlikely (fwd->bk != bck))
//                4356         malloc_printerr ("free(): corrupted unsorted chunks");
//            4357       p->fd = fwd;
//            4358       p->bk = bck;
//            4359       if (!in_smallbin_range(size))
//                4360         {
//                    4361           p->fd_nextsize = NULL;
//                    4362           p->bk_nextsize = NULL;
//                    4363         }
//            4364       bck->fd = p;
//            4365       fwd->bk = p;
//            4366
//            4367       set_head(p, size | PREV_INUSE);
//            4368       set_foot(p, size);
//            4369
//            4370       check_free_chunk(av, p);
//            4371     }
//        4372
//        4373     /*
//                  4374       If the chunk borders the current high end of memory,
//                  4375       consolidate into top
//                  4376     */
//        4377
//        4378     else {
//            4379       size += nextsize;
//            4380       set_head(p, size | PREV_INUSE);
//            4381       av->top = p;
//            4382       check_chunk(av, p);
//            4383     }
//        4384
//        4385     /*
//                  4386       If freeing a large space, consolidate possibly-surrounding
//                  4387       chunks. Then, if the total unused topmost memory exceeds trim
//                  4388       threshold, ask malloc_trim to reduce top.
//                  4389
//                  4390       Unless max_fast is 0, we don't know if there are fastbins
//                  4391       bordering top, so we cannot tell for sure whether threshold
//                  4392       has been reached unless fastbins are consolidated.  But we
//                  4393       don't want to consolidate on each free.  As a compromise,
//                  4394       consolidation is performed if FASTBIN_CONSOLIDATION_THRESHOLD
//                  4395       is reached.
//                  4396     */
//        4397
//        4398     if ((unsigned long)(size) >= FASTBIN_CONSOLIDATION_THRESHOLD) {
//            4399       if (atomic_load_relaxed (&av->have_fastchunks))
//                4400         malloc_consolidate(av);
//            4401
//            4402       if (av == &main_arena) {
//                4403 #ifndef MORECORE_CANNOT_TRIM
//                4404         if ((unsigned long)(chunksize(av->top)) >=
//                                 4405             (unsigned long)(mp_.trim_threshold))
//                    4406           systrim(mp_.top_pad, av);
//                4407 #endif
//                4408       } else {
//                    4409         /* Always try heap_trim(), even if the top chunk is not
//                                  4410            large, because the corresponding heap might go away.  */
//                    4411         heap_info *heap = heap_for_ptr(top(av));
//                    4412
//                    4413         assert(heap->ar_ptr == av);
//                    4414         heap_trim(heap, mp_.top_pad);
//                    4415       }
//            4416     }
//        4417
//        4418     if (!have_lock)
//            4419       __libc_lock_unlock (av->mutex);
//        4420   }
//    4421   /*
//            4422     If the chunk was allocated via mmap, release via munmap().
//            4423   */
//    4424
//    4425   else {
//        4426     munmap_chunk (p);
//        4427   }
//    4428 }
//4429
//4430 /*
//      4431   ------------------------- malloc_consolidate -------------------------
//      4432
//      4433   malloc_consolidate is a specialized version of free() that tears
//      4434   down chunks held in fastbins.  Free itself cannot be used for this
//      4435   purpose since, among other things, it might place chunks back onto
//      4436   fastbins.  So, instead, we need to use a minor variant of the same
//      4437   code.
//      4438 */
//4439
//4440 static void malloc_consolidate(mstate av)
//4441 {
//    4442   mfastbinptr*    fb;                 /* current fastbin being consolidated */
//    4443   mfastbinptr*    maxfb;              /* last fastbin (for loop control) */
//    4444   mchunkptr       p;                  /* current chunk being consolidated */
//    4445   mchunkptr       nextp;              /* next chunk to consolidate */
//    4446   mchunkptr       unsorted_bin;       /* bin header */
//    4447   mchunkptr       first_unsorted;     /* chunk to link to */
//    4448
//    4449   /* These have same use as in free() */
//    4450   mchunkptr       nextchunk;
//    4451   INTERNAL_SIZE_T size;
//    4452   INTERNAL_SIZE_T nextsize;
//    4453   INTERNAL_SIZE_T prevsize;
//    4454   int             nextinuse;
//    4455
//    4456   atomic_store_relaxed (&av->have_fastchunks, false);
//    4457
//    4458   unsorted_bin = unsorted_chunks(av);
//    4459
//    4460   /*
//            4461     Remove each chunk from fast bin and consolidate it, placing it
//            4462     then in unsorted bin. Among other reasons for doing this,
//            4463     placing in unsorted bin avoids needing to calculate actual bins
//            4464     until malloc is sure that chunks aren't immediately going to be
//            4465     reused anyway.
//            4466   */
//    4467
//    4468   maxfb = &fastbin (av, NFASTBINS - 1);
//    4469   fb = &fastbin (av, 0);
//    4470   do {
//        4471     p = atomic_exchange_acq (fb, NULL);
//        4472     if (p != 0) {
//            4473       do {
//                4474         {
//                    4475           unsigned int idx = fastbin_index (chunksize (p));
//                    4476           if ((&fastbin (av, idx)) != fb)
//                        4477             malloc_printerr ("malloc_consolidate(): invalid chunk size");
//                    4478         }
//                4479
//                4480         check_inuse_chunk(av, p);
//                4481         nextp = p->fd;
//                4482
//                4483         /* Slightly streamlined version of consolidation code in free() */
//                4484         size = chunksize (p);
//                4485         nextchunk = chunk_at_offset(p, size);
//                4486         nextsize = chunksize(nextchunk);
//                4487
//                4488         if (!prev_inuse(p)) {
//                    4489           prevsize = prev_size (p);
//                    4490           size += prevsize;
//                    4491           p = chunk_at_offset(p, -((long) prevsize));
//                    4492           if (__glibc_unlikely (chunksize(p) != prevsize))
//                        4493             malloc_printerr ("corrupted size vs. prev_size in fastbins");
//                    4494           unlink_chunk (av, p);
//                    4495         }
//                4496
//                4497         if (nextchunk != av->top) {
//                    4498           nextinuse = inuse_bit_at_offset(nextchunk, nextsize);
//                    4499
//                    4500           if (!nextinuse) {
//                        4501             size += nextsize;
//                        4502             unlink_chunk (av, nextchunk);
//                        4503           } else
//                            4504             clear_inuse_bit_at_offset(nextchunk, 0);
//                    4505
//                    4506           first_unsorted = unsorted_bin->fd;
//                    4507           unsorted_bin->fd = p;
//                    4508           first_unsorted->bk = p;
//                    4509
//                    4510           if (!in_smallbin_range (size)) {
//                        4511             p->fd_nextsize = NULL;
//                        4512             p->bk_nextsize = NULL;
//                        4513           }
//                    4514
//                    4515           set_head(p, size | PREV_INUSE);
//                    4516           p->bk = unsorted_bin;
//                    4517           p->fd = first_unsorted;
//                    4518           set_foot(p, size);
//                    4519         }
//                4520
//                4521         else {
//                    4522           size += nextsize;
//                    4523           set_head(p, size | PREV_INUSE);
//                    4524           av->top = p;
//                    4525         }
//                4526
//                4527       } while ( (p = nextp) != 0);
//            4528
//            4529     }
//        4530   } while (fb++ != maxfb);
//    4531 }
//4532
//4533 /*
//      4534   ------------------------------ realloc ------------------------------
//      4535 */
//4536
//4537 void*
//4538 _int_realloc(mstate av, mchunkptr oldp, INTERNAL_SIZE_T oldsize,
//                  4539              INTERNAL_SIZE_T nb)
//4540 {
//    4541   mchunkptr        newp;            /* chunk to return */
//    4542   INTERNAL_SIZE_T  newsize;         /* its size */
//    4543   void*          newmem;          /* corresponding user mem */
//    4544
//    4545   mchunkptr        next;            /* next contiguous chunk after oldp */
//    4546
//    4547   mchunkptr        remainder;       /* extra space at end of newp */
//    4548   unsigned long    remainder_size;  /* its size */
//    4549
//    4550   /* oldmem size */
//    4551   if (__builtin_expect (chunksize_nomask (oldp) <= 2 * SIZE_SZ, 0)
//               4552       || __builtin_expect (oldsize >= av->system_mem, 0))
//        4553     malloc_printerr ("realloc(): invalid old size");
//        4554
//        4555   check_inuse_chunk (av, oldp);
//        4556
//        4557   /* All callers already filter out mmap'ed chunks.  */
//        4558   assert (!chunk_is_mmapped (oldp));
//        4559
//        4560   next = chunk_at_offset (oldp, oldsize);
//        4561   INTERNAL_SIZE_T nextsize = chunksize (next);
//        4562   if (__builtin_expect (chunksize_nomask (next) <= 2 * SIZE_SZ, 0)
//                   4563       || __builtin_expect (nextsize >= av->system_mem, 0))
//            4564     malloc_printerr ("realloc(): invalid next size");
//            4565
//            4566   if ((unsigned long) (oldsize) >= (unsigned long) (nb))
//                4567     {
//                    4568       /* already big enough; split below */
//                    4569       newp = oldp;
//                    4570       newsize = oldsize;
//                    4571     }
//    4572
//    4573   else
//        4574     {
//            4575       /* Try to expand forward into top */
//            4576       if (next == av->top &&
//                           4577           (unsigned long) (newsize = oldsize + nextsize) >=
//                           4578           (unsigned long) (nb + MINSIZE))
//                4579         {
//                    4580           set_head_size (oldp, nb | (av != &main_arena ? NON_MAIN_ARENA : 0));
//                    4581           av->top = chunk_at_offset (oldp, nb);
//                    4582           set_head (av->top, (newsize - nb) | PREV_INUSE);
//                    4583           check_inuse_chunk (av, oldp);
//                    4584           return chunk2mem (oldp);
//                    4585         }
//            4586
//            4587       /* Try to expand forward into next chunk;  split off remainder below */
//            4588       else if (next != av->top &&
//                                4589                !inuse (next) &&
//                                4590                (unsigned long) (newsize = oldsize + nextsize) >=
//                                4591                (unsigned long) (nb))
//                4592         {
//                    4593           newp = oldp;
//                    4594           unlink_chunk (av, next);
//                    4595         }
//            4596
//            4597       /* allocate, copy, free */
//            4598       else
//                4599         {
//                    4600           newmem = _int_malloc (av, nb - MALLOC_ALIGN_MASK);
//                    4601           if (newmem == 0)
//                        4602             return 0; /* propagate failure */
//                    4603
//                    4604           newp = mem2chunk (newmem);
//                    4605           newsize = chunksize (newp);
//                    4606
//                    4607           /*
//                                    4608              Avoid copy if newp is next chunk after oldp.
//                                    4609            */
//                    4610           if (newp == next)
//                        4611             {
//                            4612               newsize += oldsize;
//                            4613               newp = oldp;
//                            4614             }
//                    4615           else
//                        4616             {
//                            4617               memcpy (newmem, chunk2mem (oldp), oldsize - SIZE_SZ);
//                            4618               _int_free (av, oldp, 1);
//                            4619               check_inuse_chunk (av, newp);
//                            4620               return chunk2mem (newp);
//                            4621             }
//                    4622         }
//            4623     }
//    4624
//    4625   /* If possible, free extra space in old or extended chunk */
//    4626
//    4627   assert ((unsigned long) (newsize) >= (unsigned long) (nb));
//    4628
//    4629   remainder_size = newsize - nb;
//    4630
//    4631   if (remainder_size < MINSIZE)   /* not enough extra to split off */
//        4632     {
//            4633       set_head_size (newp, newsize | (av != &main_arena ? NON_MAIN_ARENA : 0));
//            4634       set_inuse_bit_at_offset (newp, newsize);
//            4635     }
//    4636   else   /* split remainder */
//        4637     {
//            4638       remainder = chunk_at_offset (newp, nb);
//            4639       set_head_size (newp, nb | (av != &main_arena ? NON_MAIN_ARENA : 0));
//            4640       set_head (remainder, remainder_size | PREV_INUSE |
//                                 4641                 (av != &main_arena ? NON_MAIN_ARENA : 0));
//            4642       /* Mark remainder as inuse so free() won't complain */
//            4643       set_inuse_bit_at_offset (remainder, remainder_size);
//            4644       _int_free (av, remainder, 1);
//            4645     }
//    4646
//    4647   check_inuse_chunk (av, newp);
//    4648   return chunk2mem (newp);
//    4649 }
//4650
//4651 /*
//      4652    ------------------------------ memalign ------------------------------
//      4653  */
//4654
//4655 static void *
//4656 _int_memalign (mstate av, size_t alignment, size_t bytes)
//4657 {
//    4658   INTERNAL_SIZE_T nb;             /* padded  request size */
//    4659   char *m;                        /* memory returned by malloc call */
//    4660   mchunkptr p;                    /* corresponding chunk */
//    4661   char *brk;                      /* alignment point within p */
//    4662   mchunkptr newp;                 /* chunk to return */
//    4663   INTERNAL_SIZE_T newsize;        /* its size */
//    4664   INTERNAL_SIZE_T leadsize;       /* leading space before alignment point */
//    4665   mchunkptr remainder;            /* spare room at end to split off */
//    4666   unsigned long remainder_size;   /* its size */
//    4667   INTERNAL_SIZE_T size;
//    4668
//    4669
//    4670
//    4671   if (!checked_request2size (bytes, &nb))
//        4672     {
//            4673       __set_errno (ENOMEM);
//            4674       return NULL;
//            4675     }
//    4676
//    4677   /*
//            4678      Strategy: find a spot within that chunk that meets the alignment
//            4679      request, and then possibly free the leading and trailing space.
//            4680    */
//    4681
//    4682   /* Call malloc with worst case padding to hit alignment. */
//    4683
//    4684   m = (char *) (_int_malloc (av, nb + alignment + MINSIZE));
//    4685
//    4686   if (m == 0)
//        4687     return 0;           /* propagate failure */
//    4688
//    4689   p = mem2chunk (m);
//    4690
//    4691   if ((((unsigned long) (m)) % alignment) != 0)   /* misaligned */
//        4692
//        4693     { /*
//                    4694                 Find an aligned spot inside chunk.  Since we need to give back
//                    4695                 leading space in a chunk of at least MINSIZE, if the first
//                    4696                 calculation places us at a spot with less than MINSIZE leader,
//                    4697                 we can move to the next aligned spot -- we've allocated enough
//                    4698                 total room so that this is always possible.
//                    4699                  */
//            4700       brk = (char *) mem2chunk (((unsigned long) (m + alignment - 1)) &
//                                                 4701                                 - ((signed long) alignment));
//            4702       if ((unsigned long) (brk - (char *) (p)) < MINSIZE)
//                4703         brk += alignment;
//            4704
//            4705       newp = (mchunkptr) brk;
//            4706       leadsize = brk - (char *) (p);
//            4707       newsize = chunksize (p) - leadsize;
//            4708
//            4709       /* For mmapped chunks, just adjust offset */
//            4710       if (chunk_is_mmapped (p))
//                4711         {
//                    4712           set_prev_size (newp, prev_size (p) + leadsize);
//                    4713           set_head (newp, newsize | IS_MMAPPED);
//                    4714           return chunk2mem (newp);
//                    4715         }
//            4716
//            4717       /* Otherwise, give back leader, use the rest */
//            4718       set_head (newp, newsize | PREV_INUSE |
//                                 4719                 (av != &main_arena ? NON_MAIN_ARENA : 0));
//            4720       set_inuse_bit_at_offset (newp, newsize);
//            4721       set_head_size (p, leadsize | (av != &main_arena ? NON_MAIN_ARENA : 0));
//            4722       _int_free (av, p, 1);
//            4723       p = newp;
//            4724
//            4725       assert (newsize >= nb &&
//                               4726               (((unsigned long) (chunk2mem (p))) % alignment) == 0);
//            4727     }
//    4728
//    4729   /* Also give back spare room at the end */
//    4730   if (!chunk_is_mmapped (p))
//        4731     {
//            4732       size = chunksize (p);
//            4733       if ((unsigned long) (size) > (unsigned long) (nb + MINSIZE))
//                4734         {
//                    4735           remainder_size = size - nb;
//                    4736           remainder = chunk_at_offset (p, nb);
//                    4737           set_head (remainder, remainder_size | PREV_INUSE |
//                                             4738                     (av != &main_arena ? NON_MAIN_ARENA : 0));
//                    4739           set_head_size (p, nb);
//                    4740           _int_free (av, remainder, 1);
//                    4741         }
//            4742     }
//    4743
//    4744   check_inuse_chunk (av, p);
//    4745   return chunk2mem (p);
//    4746 }
//4747
//4748
//4749 /*
//      4750    ------------------------------ malloc_trim ------------------------------
//      4751  */
//4752
//4753 static int
//4754 mtrim (mstate av, size_t pad)
//4755 {
//    4756   /* Ensure all blocks are consolidated.  */
//    4757   malloc_consolidate (av);
//    4758
//    4759   const size_t ps = GLRO (dl_pagesize);
//    4760   int psindex = bin_index (ps);
//    4761   const size_t psm1 = ps - 1;
//    4762
//    4763   int result = 0;
//    4764   for (int i = 1; i < NBINS; ++i)
//        4765     if (i == 1 || i >= psindex)
//            4766       {
//                4767         mbinptr bin = bin_at (av, i);
//                4768
//                4769         for (mchunkptr p = last (bin); p != bin; p = p->bk)
//                    4770           {
//                        4771             INTERNAL_SIZE_T size = chunksize (p);
//                        4772
//                        4773             if (size > psm1 + sizeof (struct malloc_chunk))
//                            4774               {
//                                4775                 /* See whether the chunk contains at least one unused page.  */
//                                4776                 char *paligned_mem = (char *) (((uintptr_t) p
//                                                                                     4777                                                 + sizeof (struct malloc_chunk)
//                                                                                     4778                                                 + psm1) & ~psm1);
//                                4779
//                                4780                 assert ((char *) chunk2mem (p) + 4 * SIZE_SZ <= paligned_mem);
//                                4781                 assert ((char *) p + size > paligned_mem);
//                                4782
//                                4783                 /* This is the size we could potentially free.  */
//                                4784                 size -= paligned_mem - (char *) p;
//                                4785
//                                4786                 if (size > psm1)
//                                    4787                   {
//                                        4788 #if MALLOC_DEBUG
//                                            4789                     /* When debugging we simulate destroying the memory
//                                                                      4790                        content.  */
//                                            4791                     memset (paligned_mem, 0x89, size & ~psm1);
//                                        4792 #endif
//                                        4793                     __madvise (paligned_mem, size & ~psm1, MADV_DONTNEED);
//                                        4794
//                                        4795                     result = 1;
//                                        4796                   }
//                                4797               }
//                        4798           }
//                4799       }
//    4800
//    4801 #ifndef MORECORE_CANNOT_TRIM
//    4802   return result | (av == &main_arena ? systrim (pad, av) : 0);
//    4803
//    4804 #else
//        4805   return result;
//    4806 #endif
//    4807 }
//4808
//4809
//4810 int
//4811 __malloc_trim (size_t s)
//4812 {
//    4813   int result = 0;
//    4814
//    4815   if (__malloc_initialized < 0)
//        4816     ptmalloc_init ();
//        4817
//        4818   mstate ar_ptr = &main_arena;
//        4819   do
//            4820     {
//                4821       __libc_lock_lock (ar_ptr->mutex);
//                4822       result |= mtrim (ar_ptr, s);
//                4823       __libc_lock_unlock (ar_ptr->mutex);
//                4824
//                4825       ar_ptr = ar_ptr->next;
//                4826     }
//    4827   while (ar_ptr != &main_arena);
//    4828
//    4829   return result;
//    4830 }
//4831
//4832
//4833 /*
//      4834    ------------------------- malloc_usable_size -------------------------
//      4835  */
//4836
//4837 static size_t
//4838 musable (void *mem)
//4839 {
//    4840   mchunkptr p;
//    4841   if (mem != 0)
//        4842     {
//            4843       p = mem2chunk (mem);
//            4844
//            4845       if (__builtin_expect (using_malloc_checking == 1, 0))
//                4846         return malloc_check_get_size (p);
//            4847
//            4848       if (chunk_is_mmapped (p))
//                4849         {
//                    4850           if (DUMPED_MAIN_ARENA_CHUNK (p))
//                        4851             return chunksize (p) - SIZE_SZ;
//                    4852           else
//                        4853             return chunksize (p) - 2 * SIZE_SZ;
//                    4854         }
//            4855       else if (inuse (p))
//                4856         return chunksize (p) - SIZE_SZ;
//            4857     }
//    4858   return 0;
//    4859 }
//4860
//4861
//4862 size_t
//4863 __malloc_usable_size (void *m)
//4864 {
//    4865   size_t result;
//    4866
//    4867   result = musable (m);
//    4868   return result;
//    4869 }
//4870
//4871 /*
//      4872    ------------------------------ mallinfo ------------------------------
//      4873    Accumulate malloc statistics for arena AV into M.
//      4874  */
//4875
//4876 static void
//4877 int_mallinfo (mstate av, struct mallinfo *m)
//4878 {
//    4879   size_t i;
//    4880   mbinptr b;
//    4881   mchunkptr p;
//    4882   INTERNAL_SIZE_T avail;
//    4883   INTERNAL_SIZE_T fastavail;
//    4884   int nblocks;
//    4885   int nfastblocks;
//    4886
//    4887   check_malloc_state (av);
//    4888
//    4889   /* Account for top */
//    4890   avail = chunksize (av->top);
//    4891   nblocks = 1;  /* top always exists */
//    4892
//    4893   /* traverse fastbins */
//    4894   nfastblocks = 0;
//    4895   fastavail = 0;
//    4896
//    4897   for (i = 0; i < NFASTBINS; ++i)
//        4898     {
//            4899       for (p = fastbin (av, i); p != 0; p = p->fd)
//                4900         {
//                    4901           ++nfastblocks;
//                    4902           fastavail += chunksize (p);
//                    4903         }
//            4904     }
//    4905
//    4906   avail += fastavail;
//    4907
//    4908   /* traverse regular bins */
//    4909   for (i = 1; i < NBINS; ++i)
//        4910     {
//            4911       b = bin_at (av, i);
//            4912       for (p = last (b); p != b; p = p->bk)
//                4913         {
//                    4914           ++nblocks;
//                    4915           avail += chunksize (p);
//                    4916         }
//            4917     }
//    4918
//    4919   m->smblks += nfastblocks;
//    4920   m->ordblks += nblocks;
//    4921   m->fordblks += avail;
//    4922   m->uordblks += av->system_mem - avail;
//    4923   m->arena += av->system_mem;
//    4924   m->fsmblks += fastavail;
//    4925   if (av == &main_arena)
//        4926     {
//            4927       m->hblks = mp_.n_mmaps;
//            4928       m->hblkhd = mp_.mmapped_mem;
//            4929       m->usmblks = 0;
//            4930       m->keepcost = chunksize (av->top);
//            4931     }
//    4932 }
//4933
//4934
//4935 struct mallinfo
//4936 __libc_mallinfo (void)
//4937 {
//    4938   struct mallinfo m;
//    4939   mstate ar_ptr;
//    4940
//    4941   if (__malloc_initialized < 0)
//        4942     ptmalloc_init ();
//        4943
//        4944   memset (&m, 0, sizeof (m));
//        4945   ar_ptr = &main_arena;
//        4946   do
//            4947     {
//                4948       __libc_lock_lock (ar_ptr->mutex);
//                4949       int_mallinfo (ar_ptr, &m);
//                4950       __libc_lock_unlock (ar_ptr->mutex);
//                4951
//                4952       ar_ptr = ar_ptr->next;
//                4953     }
//    4954   while (ar_ptr != &main_arena);
//    4955
//    4956   return m;
//    4957 }
//4958
//4959 /*
//      4960    ------------------------------ malloc_stats ------------------------------
//      4961  */
//4962
//4963 void
//4964 __malloc_stats (void)
//4965 {
//    4966   int i;
//    4967   mstate ar_ptr;
//    4968   unsigned int in_use_b = mp_.mmapped_mem, system_b = in_use_b;
//    4969
//    4970   if (__malloc_initialized < 0)
//        4971     ptmalloc_init ();
//        4972   _IO_flockfile (stderr);
//        4973   int old_flags2 = stderr->_flags2;
//        4974   stderr->_flags2 |= _IO_FLAGS2_NOTCANCEL;
//        4975   for (i = 0, ar_ptr = &main_arena;; i++)
//            4976     {
//                4977       struct mallinfo mi;
//                4978
//                4979       memset (&mi, 0, sizeof (mi));
//                4980       __libc_lock_lock (ar_ptr->mutex);
//                4981       int_mallinfo (ar_ptr, &mi);
//                4982       fprintf (stderr, "Arena %d:\n", i);
//                4983       fprintf (stderr, "system bytes     = %10u\n", (unsigned int) mi.arena);
//                4984       fprintf (stderr, "in use bytes     = %10u\n", (unsigned int) mi.uordblks);
//                4985 #if MALLOC_DEBUG > 1
//                    4986       if (i > 0)
//                        4987         dump_heap (heap_for_ptr (top (ar_ptr)));
//                4988 #endif
//                4989       system_b += mi.arena;
//                4990       in_use_b += mi.uordblks;
//                4991       __libc_lock_unlock (ar_ptr->mutex);
//                4992       ar_ptr = ar_ptr->next;
//                4993       if (ar_ptr == &main_arena)
//                    4994         break;
//                4995     }
//    4996   fprintf (stderr, "Total (incl. mmap):\n");
//    4997   fprintf (stderr, "system bytes     = %10u\n", system_b);
//    4998   fprintf (stderr, "in use bytes     = %10u\n", in_use_b);
//    4999   fprintf (stderr, "max mmap regions = %10u\n", (unsigned int) mp_.max_n_mmaps);
//    5000   fprintf (stderr, "max mmap bytes   = %10lu\n",
//                    5001            (unsigned long) mp_.max_mmapped_mem);
//    5002   stderr->_flags2 = old_flags2;
//    5003   _IO_funlockfile (stderr);
//    5004 }
//5005
//5006
//5007 /*
//      5008    ------------------------------ mallopt ------------------------------
//      5009  */
//5010 static __always_inline int
//5011 do_set_trim_threshold (size_t value)
//5012 {
//    5013   LIBC_PROBE (memory_mallopt_trim_threshold, 3, value, mp_.trim_threshold,
//                       5014               mp_.no_dyn_threshold);
//    5015   mp_.trim_threshold = value;
//    5016   mp_.no_dyn_threshold = 1;
//    5017   return 1;
//    5018 }
//5019
//5020 static __always_inline int
//5021 do_set_top_pad (size_t value)
//5022 {
//    5023   LIBC_PROBE (memory_mallopt_top_pad, 3, value, mp_.top_pad,
//                       5024               mp_.no_dyn_threshold);
//    5025   mp_.top_pad = value;
//    5026   mp_.no_dyn_threshold = 1;
//    5027   return 1;
//    5028 }
//5029
//5030 static __always_inline int
//5031 do_set_mmap_threshold (size_t value)
//5032 {
//    5033   /* Forbid setting the threshold too high.  */
//    5034   if (value <= HEAP_MAX_SIZE / 2)
//        5035     {
//            5036       LIBC_PROBE (memory_mallopt_mmap_threshold, 3, value, mp_.mmap_threshold,
//                                   5037                   mp_.no_dyn_threshold);
//            5038       mp_.mmap_threshold = value;
//            5039       mp_.no_dyn_threshold = 1;
//            5040       return 1;
//            5041     }
//    5042   return 0;
//    5043 }
//5044
//5045 static __always_inline int
//5046 do_set_mmaps_max (int32_t value)
//5047 {
//    5048   LIBC_PROBE (memory_mallopt_mmap_max, 3, value, mp_.n_mmaps_max,
//                       5049               mp_.no_dyn_threshold);
//    5050   mp_.n_mmaps_max = value;
//    5051   mp_.no_dyn_threshold = 1;
//    5052   return 1;
//    5053 }
//5054
//5055 static __always_inline int
//5056 do_set_mallopt_check (int32_t value)
//5057 {
//    5058   return 1;
//    5059 }
//5060
//5061 static __always_inline int
//5062 do_set_perturb_byte (int32_t value)
//5063 {
//    5064   LIBC_PROBE (memory_mallopt_perturb, 2, value, perturb_byte);
//    5065   perturb_byte = value;
//    5066   return 1;
//    5067 }
//5068
//5069 static __always_inline int
//5070 do_set_arena_test (size_t value)
//5071 {
//    5072   LIBC_PROBE (memory_mallopt_arena_test, 2, value, mp_.arena_test);
//    5073   mp_.arena_test = value;
//    5074   return 1;
//    5075 }
//5076
//5077 static __always_inline int
//5078 do_set_arena_max (size_t value)
//5079 {
//    5080   LIBC_PROBE (memory_mallopt_arena_max, 2, value, mp_.arena_max);
//    5081   mp_.arena_max = value;
//    5082   return 1;
//    5083 }
//5084
//5085 #if USE_TCACHE
//5086 static __always_inline int
//5087 do_set_tcache_max (size_t value)
//5088 {
//    5089   if (value >= 0 && value <= MAX_TCACHE_SIZE)
//        5090     {
//            5091       LIBC_PROBE (memory_tunable_tcache_max_bytes, 2, value, mp_.tcache_max_bytes);
//            5092       mp_.tcache_max_bytes = value;
//            5093       mp_.tcache_bins = csize2tidx (request2size(value)) + 1;
//            5094     }
//    5095   return 1;
//    5096 }
//5097
//5098 static __always_inline int
//5099 do_set_tcache_count (size_t value)
//5100 {
//    5101   if (value <= MAX_TCACHE_COUNT)
//        5102     {
//            5103       LIBC_PROBE (memory_tunable_tcache_count, 2, value, mp_.tcache_count);
//            5104       mp_.tcache_count = value;
//            5105     }
//    5106   return 1;
//    5107 }
//5108
//5109 static __always_inline int
//5110 do_set_tcache_unsorted_limit (size_t value)
//5111 {
//    5112   LIBC_PROBE (memory_tunable_tcache_unsorted_limit, 2, value, mp_.tcache_unsorted_limit);
//    5113   mp_.tcache_unsorted_limit = value;
//    5114   return 1;
//    5115 }
//5116 #endif
//5117
//5118 int
//5119 __libc_mallopt (int param_number, int value)
//5120 {
//    5121   mstate av = &main_arena;
//    5122   int res = 1;
//    5123
//    5124   if (__malloc_initialized < 0)
//        5125     ptmalloc_init ();
//        5126   __libc_lock_lock (av->mutex);
//        5127
//        5128   LIBC_PROBE (memory_mallopt, 2, param_number, value);
//        5129
//        5130   /* We must consolidate main arena before changing max_fast
//                5131      (see definition of set_max_fast).  */
//        5132   malloc_consolidate (av);
//        5133
//        5134   switch (param_number)
//        5135     {
//            5136     case M_MXFAST:
//            5137       if (value >= 0 && value <= MAX_FAST_SIZE)
//                5138         {
//                    5139           LIBC_PROBE (memory_mallopt_mxfast, 2, value, get_max_fast ());
//                    5140           set_max_fast (value);
//                    5141         }
//            5142       else
//                5143         res = 0;
//            5144       break;
//            5145
//            5146     case M_TRIM_THRESHOLD:
//            5147       do_set_trim_threshold (value);
//            5148       break;
//            5149
//            5150     case M_TOP_PAD:
//            5151       do_set_top_pad (value);
//            5152       break;
//            5153
//            5154     case M_MMAP_THRESHOLD:
//            5155       res = do_set_mmap_threshold (value);
//            5156       break;
//            5157
//            5158     case M_MMAP_MAX:
//            5159       do_set_mmaps_max (value);
//            5160       break;
//            5161
//            5162     case M_CHECK_ACTION:
//            5163       do_set_mallopt_check (value);
//            5164       break;
//            5165
//            5166     case M_PERTURB:
//            5167       do_set_perturb_byte (value);
//            5168       break;
//            5169
//            5170     case M_ARENA_TEST:
//            5171       if (value > 0)
//                5172         do_set_arena_test (value);
//            5173       break;
//            5174
//            5175     case M_ARENA_MAX:
//            5176       if (value > 0)
//                5177         do_set_arena_max (value);
//            5178       break;
//            5179     }
//    5180   __libc_lock_unlock (av->mutex);
//    5181   return res;
//    5182 }
//5183 libc_hidden_def (__libc_mallopt)
//5184
//5185
//5186 /*
//      5187    -------------------- Alternative MORECORE functions --------------------
//      5188  */
//5189
//5190
//5191 /*
//      5192    General Requirements for MORECORE.
//      5193
//      5194    The MORECORE function must have the following properties:
//      5195
//      5196    If MORECORE_CONTIGUOUS is false:
//      5197
//      5198  * MORECORE must allocate in multiples of pagesize. It will
//      5199       only be called with arguments that are multiples of pagesize.
//      5200
//      5201  * MORECORE(0) must return an address that is at least
//      5202       MALLOC_ALIGNMENT aligned. (Page-aligning always suffices.)
//      5203
//      5204    else (i.e. If MORECORE_CONTIGUOUS is true):
//      5205
//      5206  * Consecutive calls to MORECORE with positive arguments
//      5207       return increasing addresses, indicating that space has been
//      5208       contiguously extended.
//      5209
//      5210  * MORECORE need not allocate in multiples of pagesize.
//      5211       Calls to MORECORE need not have args of multiples of pagesize.
//      5212
//      5213  * MORECORE need not page-align.
//      5214
//      5215    In either case:
//      5216
//      5217  * MORECORE may allocate more memory than requested. (Or even less,
//      5218       but this will generally result in a malloc failure.)
//      5219
//      5220  * MORECORE must not allocate memory when given argument zero, but
//      5221       instead return one past the end address of memory from previous
//      5222       nonzero call. This malloc does NOT call MORECORE(0)
//      5223       until at least one call with positive arguments is made, so
//      5224       the initial value returned is not important.
//      5225
//      5226  * Even though consecutive calls to MORECORE need not return contiguous
//      5227       addresses, it must be OK for malloc'ed chunks to span multiple
//      5228       regions in those cases where they do happen to be contiguous.
//      5229
//      5230  * MORECORE need not handle negative arguments -- it may instead
//      5231       just return MORECORE_FAILURE when given negative arguments.
//      5232       Negative arguments are always multiples of pagesize. MORECORE
//      5233       must not misinterpret negative args as large positive unsigned
//      5234       args. You can suppress all such calls from even occurring by defining
//      5235       MORECORE_CANNOT_TRIM,
//      5236
//      5237    There is some variation across systems about the type of the
//      5238    argument to sbrk/MORECORE. If size_t is unsigned, then it cannot
//      5239    actually be size_t, because sbrk supports negative args, so it is
//      5240    normally the signed type of the same width as size_t (sometimes
//      5241    declared as "intptr_t", and sometimes "ptrdiff_t").  It doesn't much
//      5242    matter though. Internally, we use "long" as arguments, which should
//      5243    work across all reasonable possibilities.
//      5244
//      5245    Additionally, if MORECORE ever returns failure for a positive
//      5246    request, then mmap is used as a noncontiguous system allocator. This
//      5247    is a useful backup strategy for systems with holes in address spaces
//      5248    -- in this case sbrk cannot contiguously expand the heap, but mmap
//      5249    may be able to map noncontiguous space.
//      5250
//      5251    If you'd like mmap to ALWAYS be used, you can define MORECORE to be
//      5252    a function that always returns MORECORE_FAILURE.
//      5253
//      5254    If you are using this malloc with something other than sbrk (or its
//      5255    emulation) to supply memory regions, you probably want to set
//      5256    MORECORE_CONTIGUOUS as false.  As an example, here is a custom
//      5257    allocator kindly contributed for pre-OSX macOS.  It uses virtually
//      5258    but not necessarily physically contiguous non-paged memory (locked
//      5259    in, present and won't get swapped out).  You can use it by
//      5260    uncommenting this section, adding some #includes, and setting up the
//      5261    appropriate defines above:
//      5262
//      5263  *#define MORECORE osMoreCore
//      5264  *#define MORECORE_CONTIGUOUS 0
//      5265
//      5266    There is also a shutdown routine that should somehow be called for
//      5267    cleanup upon program exit.
//      5268
//      5269  *#define MAX_POOL_ENTRIES 100
//      5270  *#define MINIMUM_MORECORE_SIZE  (64 * 1024)
//      5271    static int next_os_pool;
//      5272    void *our_os_pools[MAX_POOL_ENTRIES];
//      5273
//      5274    void *osMoreCore(int size)
//      5275    {
//      5276     void *ptr = 0;
//      5277     static void *sbrk_top = 0;
//      5278
//      5279     if (size > 0)
//      5280     {
//      5281       if (size < MINIMUM_MORECORE_SIZE)
//      5282          size = MINIMUM_MORECORE_SIZE;
//      5283       if (CurrentExecutionLevel() == kTaskLevel)
//      5284          ptr = PoolAllocateResident(size + RM_PAGE_SIZE, 0);
//      5285       if (ptr == 0)
//      5286       {
//      5287         return (void *) MORECORE_FAILURE;
//      5288       }
//      5289       // save ptrs so they can be freed during cleanup
//      5290       our_os_pools[next_os_pool] = ptr;
//      5291       next_os_pool++;
//      5292       ptr = (void *) ((((unsigned long) ptr) + RM_PAGE_MASK) & ~RM_PAGE_MASK);
//      5293       sbrk_top = (char *) ptr + size;
//      5294       return ptr;
//      5295     }
//      5296     else if (size < 0)
//      5297     {
//      5298       // we don't currently support shrink behavior
//      5299       return (void *) MORECORE_FAILURE;
//      5300     }
//      5301     else
//      5302     {
//      5303       return sbrk_top;
//      5304     }
//      5305    }
//      5306
//      5307    // cleanup any allocated memory pools
//      5308    // called as last thing before shutting down driver
//      5309
//      5310    void osCleanupMem(void)
//      5311    {
//      5312     void **ptr;
//      5313
//      5314     for (ptr = our_os_pools; ptr < &our_os_pools[MAX_POOL_ENTRIES]; ptr++)
//      5315       if (*ptr)
//      5316       {
//      5317          PoolDeallocate(*ptr);
//      5318  * ptr = 0;
//      5319       }
//      5320    }
//      5321
//      5322  */
//5323
//5324
//5325 /* Helper code.  */
//5326
//5327 extern char **__libc_argv attribute_hidden;
//5328
//5329 static void
//5330 malloc_printerr (const char *str)
//5331 {
//    5332   __libc_message (do_abort, "%s\n", str);
//    5333   __builtin_unreachable ();
//    5334 }
//5335
//5336 /* We need a wrapper function for one of the additions of POSIX.  */
//5337 int
//5338 __posix_memalign (void **memptr, size_t alignment, size_t size)
//5339 {
//    5340   void *mem;
//    5341
//    5342   /* Test whether the SIZE argument is valid.  It must be a power of
//            5343      two multiple of sizeof (void *).  */
//    5344   if (alignment % sizeof (void *) != 0
//               5345       || !powerof2 (alignment / sizeof (void *))
//               5346       || alignment == 0)
//        5347     return EINVAL;
//    5348
//    5349
//    5350   void *address = RETURN_ADDRESS (0);
//    5351   mem = _mid_memalign (alignment, size, address);
//    5352
//    5353   if (mem != NULL)
//        5354     {
//            5355       *memptr = mem;
//            5356       return 0;
//            5357     }
//    5358
//    5359   return ENOMEM;
//    5360 }
//5361 weak_alias (__posix_memalign, posix_memalign)
//5362
//5363
//5364 int
//5365 __malloc_info (int options, FILE *fp)
//5366 {
//    5367   /* For now, at least.  */
//    5368   if (options != 0)
//        5369     return EINVAL;
//    5370
//    5371   int n = 0;
//    5372   size_t total_nblocks = 0;
//    5373   size_t total_nfastblocks = 0;
//    5374   size_t total_avail = 0;
//    5375   size_t total_fastavail = 0;
//    5376   size_t total_system = 0;
//    5377   size_t total_max_system = 0;
//    5378   size_t total_aspace = 0;
//    5379   size_t total_aspace_mprotect = 0;
//    5380
//    5381
//    5382
//    5383   if (__malloc_initialized < 0)
//        5384     ptmalloc_init ();
//        5385
//        5386   fputs ("<malloc version=\"1\">\n", fp);
//        5387
//        5388   /* Iterate over all arenas currently in use.  */
//        5389   mstate ar_ptr = &main_arena;
//        5390   do
//            5391     {
//                5392       fprintf (fp, "<heap nr=\"%d\">\n<sizes>\n", n++);
//                5393
//                5394       size_t nblocks = 0;
//                5395       size_t nfastblocks = 0;
//                5396       size_t avail = 0;
//                5397       size_t fastavail = 0;
//                5398       struct
//                5399       {
//                    5400         size_t from;
//                    5401         size_t to;
//                    5402         size_t total;
//                    5403         size_t count;
//                    5404       } sizes[NFASTBINS + NBINS - 1];
//                5405 #define nsizes (sizeof (sizes) / sizeof (sizes[0]))
//                5406
//                5407       __libc_lock_lock (ar_ptr->mutex);
//                5408
//                5409       for (size_t i = 0; i < NFASTBINS; ++i)
//                    5410         {
//                        5411           mchunkptr p = fastbin (ar_ptr, i);
//                        5412           if (p != NULL)
//                            5413             {
//                                5414               size_t nthissize = 0;
//                                5415               size_t thissize = chunksize (p);
//                                5416
//                                5417               while (p != NULL)
//                                    5418                 {
//                                        5419                   ++nthissize;
//                                        5420                   p = p->fd;
//                                        5421                 }
//                                5422
//                                5423               fastavail += nthissize * thissize;
//                                5424               nfastblocks += nthissize;
//                                5425               sizes[i].from = thissize - (MALLOC_ALIGNMENT - 1);
//                                5426               sizes[i].to = thissize;
//                                5427               sizes[i].count = nthissize;
//                                5428             }
//                        5429           else
//                            5430             sizes[i].from = sizes[i].to = sizes[i].count = 0;
//                        5431
//                        5432           sizes[i].total = sizes[i].count * sizes[i].to;
//                        5433         }
//                5434
//                5435
//                5436       mbinptr bin;
//                5437       struct malloc_chunk *r;
//                5438
//                5439       for (size_t i = 1; i < NBINS; ++i)
//                    5440         {
//                        5441           bin = bin_at (ar_ptr, i);
//                        5442           r = bin->fd;
//                        5443           sizes[NFASTBINS - 1 + i].from = ~((size_t) 0);
//                        5444           sizes[NFASTBINS - 1 + i].to = sizes[NFASTBINS - 1 + i].total
//                        5445                                           = sizes[NFASTBINS - 1 + i].count = 0;
//                        5446
//                        5447           if (r != NULL)
//                            5448             while (r != bin)
//                                5449               {
//                                    5450                 size_t r_size = chunksize_nomask (r);
//                                    5451                 ++sizes[NFASTBINS - 1 + i].count;
//                                    5452                 sizes[NFASTBINS - 1 + i].total += r_size;
//                                    5453                 sizes[NFASTBINS - 1 + i].from
//                                    5454                   = MIN (sizes[NFASTBINS - 1 + i].from, r_size);
//                                    5455                 sizes[NFASTBINS - 1 + i].to = MAX (sizes[NFASTBINS - 1 + i].to,
//                                                                                            5456                                                    r_size);
//                                    5457
//                                    5458                 r = r->fd;
//                                    5459               }
//                        5460
//                        5461           if (sizes[NFASTBINS - 1 + i].count == 0)
//                            5462             sizes[NFASTBINS - 1 + i].from = 0;
//                        5463           nblocks += sizes[NFASTBINS - 1 + i].count;
//                        5464           avail += sizes[NFASTBINS - 1 + i].total;
//                        5465         }
//                5466
//                5467       size_t heap_size = 0;
//                5468       size_t heap_mprotect_size = 0;
//                5469       size_t heap_count = 0;
//                5470       if (ar_ptr != &main_arena)
//                    5471         {
//                        5472           /* Iterate over the arena heaps from back to front.  */
//                        5473           heap_info *heap = heap_for_ptr (top (ar_ptr));
//                        5474           do
//                            5475             {
//                                5476               heap_size += heap->size;
//                                5477               heap_mprotect_size += heap->mprotect_size;
//                                5478               heap = heap->prev;
//                                5479               ++heap_count;
//                                5480             }
//                        5481           while (heap != NULL);
//                        5482         }
//                5483
//                5484       __libc_lock_unlock (ar_ptr->mutex);
//                5485
//                5486       total_nfastblocks += nfastblocks;
//                5487       total_fastavail += fastavail;
//                5488
//                5489       total_nblocks += nblocks;
//                5490       total_avail += avail;
//                5491
//                5492       for (size_t i = 0; i < nsizes; ++i)
//                    5493         if (sizes[i].count != 0 && i != NFASTBINS)
//                        5494           fprintf (fp, "                                                              \
//                                                5495   <size from=\"%zu\" to=\"%zu\" total=\"%zu\" count=\"%zu\"/>\n",
//                                                5496                    sizes[i].from, sizes[i].to, sizes[i].total, sizes[i].count);
//                5497
//                5498       if (sizes[NFASTBINS].count != 0)
//                    5499         fprintf (fp, "\
//                                          5500   <unsorted from=\"%zu\" to=\"%zu\" total=\"%zu\" count=\"%zu\"/>\n",
//                                          5501                  sizes[NFASTBINS].from, sizes[NFASTBINS].to,
//                                          5502                  sizes[NFASTBINS].total, sizes[NFASTBINS].count);
//                5503
//                5504       total_system += ar_ptr->system_mem;
//                5505       total_max_system += ar_ptr->max_system_mem;
//                5506
//                5507       fprintf (fp,
//                                    5508                "</sizes>\n<total type=\"fast\" count=\"%zu\" size=\"%zu\"/>\n"
//                                    5509                "<total type=\"rest\" count=\"%zu\" size=\"%zu\"/>\n"
//                                    5510                "<system type=\"current\" size=\"%zu\"/>\n"
//                                    5511                "<system type=\"max\" size=\"%zu\"/>\n",
//                                    5512                nfastblocks, fastavail, nblocks, avail,
//                                    5513                ar_ptr->system_mem, ar_ptr->max_system_mem);
//                5514
//                5515       if (ar_ptr != &main_arena)
//                    5516         {
//                        5517           fprintf (fp,
//                                                5518                    "<aspace type=\"total\" size=\"%zu\"/>\n"
//                                                5519                    "<aspace type=\"mprotect\" size=\"%zu\"/>\n"
//                                                5520                    "<aspace type=\"subheaps\" size=\"%zu\"/>\n",
//                                                5521                    heap_size, heap_mprotect_size, heap_count);
//                        5522           total_aspace += heap_size;
//                        5523           total_aspace_mprotect += heap_mprotect_size;
//                        5524         }
//                5525       else
//                    5526         {
//                        5527           fprintf (fp,
//                                                5528                    "<aspace type=\"total\" size=\"%zu\"/>\n"
//                                                5529                    "<aspace type=\"mprotect\" size=\"%zu\"/>\n",
//                                                5530                    ar_ptr->system_mem, ar_ptr->system_mem);
//                        5531           total_aspace += ar_ptr->system_mem;
//                        5532           total_aspace_mprotect += ar_ptr->system_mem;
//                        5533         }
//                5534
//                5535       fputs ("</heap>\n", fp);
//                5536       ar_ptr = ar_ptr->next;
//                5537     }
//    5538   while (ar_ptr != &main_arena);
//    5539
//    5540   fprintf (fp,
//                    5541            "<total type=\"fast\" count=\"%zu\" size=\"%zu\"/>\n"
//                    5542            "<total type=\"rest\" count=\"%zu\" size=\"%zu\"/>\n"
//                    5543            "<total type=\"mmap\" count=\"%d\" size=\"%zu\"/>\n"
//                    5544            "<system type=\"current\" size=\"%zu\"/>\n"
//                    5545            "<system type=\"max\" size=\"%zu\"/>\n"
//                    5546            "<aspace type=\"total\" size=\"%zu\"/>\n"
//                    5547            "<aspace type=\"mprotect\" size=\"%zu\"/>\n"
//                    5548            "</malloc>\n",
//                    5549            total_nfastblocks, total_fastavail, total_nblocks, total_avail,
//                    5550            mp_.n_mmaps, mp_.mmapped_mem,
//                    5551            total_system, total_max_system,
//                    5552            total_aspace, total_aspace_mprotect);
//    5553
//    5554   return 0;
//    5555 }
//5556 weak_alias (__malloc_info, malloc_info)
//5557
//5558
//5559 strong_alias (__libc_calloc, __calloc) weak_alias (__libc_calloc, calloc)
//5560 strong_alias (__libc_free, __free) strong_alias (__libc_free, free)
//5561 strong_alias (__libc_malloc, __malloc) strong_alias (__libc_malloc, malloc)
//5562 strong_alias (__libc_memalign, __memalign)
//5563 weak_alias (__libc_memalign, memalign)
//5564 strong_alias (__libc_realloc, __realloc) strong_alias (__libc_realloc, realloc)
//5565 strong_alias (__libc_valloc, __valloc) weak_alias (__libc_valloc, valloc)
//5566 strong_alias (__libc_pvalloc, __pvalloc) weak_alias (__libc_pvalloc, pvalloc)
//5567 strong_alias (__libc_mallinfo, __mallinfo)
//5568 weak_alias (__libc_mallinfo, mallinfo)
//5569 strong_alias (__libc_mallopt, __mallopt) weak_alias (__libc_mallopt, mallopt)
//5570
//5571 weak_alias (__malloc_stats, malloc_stats)
//5572 weak_alias (__malloc_usable_size, malloc_usable_size)
//5573 weak_alias (__malloc_trim, malloc_trim)
//5574
//5575 #if SHLIB_COMPAT (libc, GLIBC_2_0, GLIBC_2_26)
//5576 compat_symbol (libc, __libc_free, cfree, GLIBC_2_0);
//5577 #endif
//5578
//5579 /* ------------------------------------------------------------
//      5580    History:
//      5581
//      5582    [see ftp://g.oswego.edu/pub/misc/malloc.c for the history of dlmalloc]
//      5583
//      5584  */
//5585 /*
//      5586  * Local variables:
//      5587  * c-basic-offset: 2
//      5588  * End:
//      5589  */
