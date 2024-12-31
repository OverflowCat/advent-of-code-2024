package day03

import std.regex.*
import std.fs.*
import std.convert.*

func readInput(): String {
    let filePath: Path = Path("./input.txt")

    if (!File.exists(filePath)) {
        throw Exception("Error: The file 'input.txt' does not exist.")
    }

    var file: File = File(filePath, OpenOption.Open(true, false))

    let fileContent: Array<Byte> = file.readToEnd()
    file.close()

    String.fromUtf8(fileContent)
}

func a(): Unit {
    let r = Regex(#"mul\((\d+),(\d+)\)"#).matcher(readInput())
    var sum = 0
    while (let Some(matchData) <- r.find()) {
        // println("Found match: ${matchData.matchStr(0)} (${matchData.matchStr(1)},${matchData.matchStr(2)})")
        let a = Int64.parse(matchData.matchStr(1))
        let b = Int64.parse(matchData.matchStr(2))
        let product = a * b
        sum += product
    }
    println("[Part A] Sum of all products: ${sum}")
}

func b(): Unit {
    let r = Regex(#"mul\((\d+),(\d+)\)|do\(\)|don't\(\)"#).matcher(readInput())
    var sum = 0
    var enabled = true
    while (let Some(matchData) <- r.find()) {
        let op = matchData.matchStr()
        // println("op: ${op}")
        if (op == "do()") {
            enabled = true
        } else if (op == "don't()") {
            enabled = false
        } else if (enabled) {
            let a = Int64.parse(matchData.matchStr(1))
            let b = Int64.parse(matchData.matchStr(2))
            let product = a * b
            sum += product
        }
    }
    println("[Part B] Sum of all products: ${sum}")
}

main() {
    a()
    b()
}
