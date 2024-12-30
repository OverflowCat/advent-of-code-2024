package day01

import std.fs.*
import std.collection.*
import std.convert.*
import std.sort.*

// Sort in-place
func sortArr(arr: ArrayList<UInt32>) {
    arr.sortBy(stable: false){ rht: UInt32, lht: UInt32 =>
        if (rht < lht) {
            return Ordering.LT
        }
        if (rht > lht) {
            return Ordering.GT
        }
        return Ordering.EQ
    }
}

func part1(group1: ArrayList<UInt32>, group2: ArrayList<UInt32>) {
    sortArr(group1)
    sortArr(group2)

    var totalDiff: UInt32 = 0
    for (i in 0..group1.size - 1) {
        let diff = if (group1[i] > group2[i]) {
            group1[i] - group2[i]
        } else {
            group2[i] - group1[i]
        }
        totalDiff += diff
    }

    println("Part 1: totalDiff = ${totalDiff}")
}

func part2(group1: ArrayList<UInt32>, group2: ArrayList<UInt32>) {
        var count2 = Array<UInt32>(100000) { _ => 0 }
    
    for (item in group2) {
        count2[Int64(item)] += 1
    }

    var similarity: UInt32 = 0
    for (i in 0..group1.size) {
        let num = group1[i]
        // println(count2[Int64(num)])
        similarity += num * count2[Int64(num)]
    }

    println("Part 2: similarity = ${similarity}")
}

main() {
    let filePath: Path = Path("./input.txt")

    if (!File.exists(filePath)) {
        println("Error: The file 'input.txt' does not exist.")
        return 1
    }

    var file: File = File(filePath, OpenOption.Open(true, false))

    let fileContent: Array<Byte> = file.readToEnd()
    file.close()

    let contentString: String = String.fromUtf8(fileContent)

    let lines = contentString.split('\n')

    var group1 = ArrayList<UInt32>([])
    var group2 = ArrayList<UInt32>([])

    for (line in lines) {
        let numbers = line.split('   ')
        group1.append((UInt32.parse(numbers[0])))
        group2.append((UInt32.parse(numbers[1])))
    }

    part2(group1, group2)
    part1(group1, group2)

    return 0
}
