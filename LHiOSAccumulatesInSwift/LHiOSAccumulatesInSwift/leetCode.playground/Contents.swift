import UIKit

// * Definition for singly-linked list.
class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
    self.val = val
    self.next = nil
    }
}

class Solution {
    
    //8.atoi 字符串转整数
    func myAtoi(_ str: String) -> Int {
        var result = 0
        
        
        
        return result
        
    }

    //7.整数反转：120->21, 321->123
    func reverse(_ x: Int) -> Int {
        var y = x > 0 ? x : -x
        var max:Int = 0x100000000 / 2
        max = x < 0 ? max + 1 : max
        var result = 0
        while y > 0 {
            result *= 10
            result += y % 10
            y = y / 10
        }
        
        if result > max {
            return 0
        }
        return x > 0 ? result : -result
    }
    
    
    //2.两数相加
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var carrier = 0
        var result:ListNode?, current:ListNode?
        var p = l1, q = l2
        while p != nil || q != nil {
            var value = carrier + (p == nil ? 0 : p!.val) + (q == nil ? 0 : q!.val)
            p = p?.next
            q = q?.next
            carrier = value / 10
            value = value % 10
            let node = ListNode(value)
            
            if result == nil {
                result = node
                current = node
            } else {
                current?.next = node
                current = node
            }
        }
        if carrier > 0 {
            current?.next = ListNode(carrier)
        }

        return result
    }
    
}

let s = Solution()
