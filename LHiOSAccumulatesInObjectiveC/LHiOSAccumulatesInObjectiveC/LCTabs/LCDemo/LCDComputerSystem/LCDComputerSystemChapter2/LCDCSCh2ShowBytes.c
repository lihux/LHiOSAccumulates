//
//  LCDCSCh2ShowBytes.c
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/25.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#include "LCDCSCh2ShowBytes.h"

void lc_show_bytes(lc_byte_pointer start, size_t len) {
    size_t i;
    for (i = 0; i < len; i++) {
        printf(" %.2x", start[i]);
    }
    printf("\n");
}
