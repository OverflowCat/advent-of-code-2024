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

    println(totalDiff)

    return 0
}
