//: Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

//lihux20160124
print("Hello, swift world")
print("")
let implicitInteger = 70
let explicitDouble: Double = 70
let label = "the width is "
let width = 94
let widthLabel = label + String(width)
let sayWhat = "还可以这样组装string：\(label),width is \(width)"

//Create Array & Dictionary : all are structure which is not the same as OC
var carList = ["Benz GLC", "BMW", "Audi"]
var myDreamCarDic = ["myFirstCar": "Benz GLC", "myFavoriteCar": "BMW 3"]
print(carList[0], myDreamCarDic["myFavoriteCar"])

switch label {
    case "the width is ":
    print("go to switch a")
default:
    print("oh my god, go to switch default")
}

var j = 0
for var i in 0...4 {
    j = j + 1
}
print(j)
j = 0

//NOTE Changed in swift 2.0: 0..4 not work anymore
for i in 0..<4 {
    j = j + 1
}
print(j)

//Define a Function
func greeting(name: String, day: String) -> String
{
    return "Hello \(name), today is \(day)"
}

//Use tuple to make a compound for function return value
func tupleExample() -> (a:Int, b:Int, c: Int, d: Int)
{
    return(1, 2, 3, 4)
}

var tuple = tupleExample()
print(tuple.a)
print(tuple.0)
print(tuple)

//可变参数
func varibaleArgumentsFunction(numbers: Int...)
{
    var sum = 0
    for number in numbers {
        sum += number
    }
    print(sum)
}



























