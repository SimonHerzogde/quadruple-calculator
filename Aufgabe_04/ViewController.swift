//
//  ViewController.swift
//  Aufgabe_04
//
//  Created by Simon Herzog on 26.03.21.
//

import Cocoa

class ViewController: NSViewController {
    
    //Outlets für label, Eingabefeld und die Radio-Buttons
    @IBOutlet weak var inputNumber: NSTextField!
    @IBOutlet weak var labelResult: NSTextField!
    @IBOutlet weak var buttonDualDezi: NSButton!
    @IBOutlet weak var buttonDeziDual: NSButton!
    @IBOutlet weak var buttonRomanArab: NSButton!
    @IBOutlet weak var buttonArabRoman: NSButton!
    
    
    
    //Action für den Beenden Button die die App beendet
    @IBAction func clickedQuit(_ sender: Any) {
        NSApplication.shared.terminate(self)
        
    }
    //Action für den Umrechnen Button, habe der Übersicht halber die Anweisungen für die einzelnen Operationen in eigene Methoden gepackt
    @IBAction func clickedConvert(_ sender: Any) {
        //je nach dem welcher Radio-Button aktiviert ist, geht es in den entsprechenden if-Zweig
        
        //Berechnung von Binärzahl zu Dezimalzahl
        if buttonDualDezi.state == NSControl.StateValue.on {
            calcBinToDec()
        }
        
        //Berechnung von Dezimalzahl zu Binärzahl
        if buttonDeziDual.state == NSControl.StateValue.on {
            calcDecToBin()
        }
        
        //Berechnung von römsicher Zahl zu arabischer Zahl
        if buttonRomanArab.state == NSControl.StateValue.on {
            calcRomToArab()
        }
        
        //Berechnung von arabischer Zahl zu römischer Zahl
        if buttonArabRoman.state == NSControl.StateValue.on {
            calcArabToRom()
        }
    }
    
    func calcBinToDec() {
        //Zuweisung der eingegebenen Binärzahl als Character-Array
        let binary = Array(inputNumber.stringValue)
        //Variable für Ergebnis als Double
        var result = 0.0
        //Anzahl der Elemente der eingebenen Binärzahl -1 entspricht dem höchsten Exponenten in der Berechnung
        var exponent = binary.count - 1

        //Schleife läuft von 0 bis Anzahl der Elemente der Binärzahl -1 (entspricht var exponent)
        for num in 0...exponent{
            //Wenn die Zahl am aktuellen Index "1" entspricht, wird die if-Struktur ausgeführt
            if binary[num] == "1"{
                //dabei wird zur Basis 2 mit aktuellem Exponent (anfangs Elementeanzahl -1) potenziert, mit result addiert und das neue Ergebnis result zugewiesen
                result += pow(2.0, Double(exponent))
            }
            //Exponent wird um 1 reduziert
            exponent -= 1
        }
        //Aktualisierung der Anzeige mit Ergebnis
        labelResult.doubleValue = result
    }
    
    
    func calcDecToBin() {
        //var binary ist String
        var binary = ""
        //Eingegebene Zahl als Int zuweisen
        var decimal = inputNumber.integerValue
        //Schleife läuft solange, wie decimal größer 0 ist
        while decimal > 0{
            //Eingegebene Zahl wird durch zwei geteilt und der Rest wird dem String binary angehängt
            binary.append(String(decimal % 2))
            //decimal wird durch 2 geteilt und sich selbst wieder zugewiesen
            decimal /= 2
        }
        //Ausgabe der Binärzahl in umgekehrter Reihenfolge
        labelResult.stringValue = String(binary.reversed())
    }
    
    
    func calcRomToArab() {
        //Festlegung der römischen Zahlen und deren arabisches Äquivalent als Schlüssel-Wert-Paare (Dictionary)
        let romanNumbers = ["I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000]
        
        //eingegebene römische Zahl holen und als Char-Array zuweisen
        let romanNum = Array(inputNumber.stringValue)
        //leeres Int-Array erstellen
        var arabNum = [Int]()
        
        //eingegebene einzelnen römische Zahlen in arabisches Äquivalent konvertieren
        for num in romanNum {
            arabNum.append(romanNumbers[String(num)]!)
        }
        
        //Variablen für Ergebnis, die zuvor bearbeitete Zahl und die aktuelle Zahl
        var result = 0
        var numBefore = 0
        var currentNum = 0
        
        
        //Schleife läuft alle Zahlen von 0 bis Anzahl der Elemente -1 in arabNum
        for num in 0...arabNum.count - 1 {
            //die Zahl aus dem vorherigen Durchlauf, die jetzt noch in currentNum gespeichert ist, wird numBefore zugewiesen
            numBefore = currentNum
            //die aktuelle Zahl, aufgerufen mit Index in arabNum wird currentNum zugewiesen
            currentNum = arabNum[num]

            //Speicherung der ersten Zahl in result
            if numBefore == 0 {
                result = currentNum
                continue
            }
            
            //wenn vorherige Zahl kleiner als jetzige Zahl ist, müssen diese Subtrahiert werden. UND && verhindert Ausführung beim ersten Durchlauf, da hier numBefore immer 0 ist.
            if numBefore < currentNum && numBefore != 0 {
                //wenn numBefore dem aktuellen Zwischenergebnis entspricht, z.B. beim ersten Durchlauf, obwohl numBefore kleiner als currentNum ist, darf die daraus resultierende Zahl (currentNum - numBefore) nicht zu result addiert werden
                if numBefore == result {
                    result = currentNum - numBefore
                    continue
                }
                //Zahl wird zu result addiert
                result += currentNum - numBefore
                continue
            }
            
            //wenn aktuelle Zahl kleiner ist als die Zahl danach ODER die aktuelle ist gleich der davor, so wird die aktuelle einfach zu result addiert, ausser...
            if currentNum < numBefore || currentNum == numBefore {
                //wenn Index der aktuellen Zahl gleich des Index der letzten Zahl im Array ist, wird ebenfalls addiert, wenn aber der Index der aktuellen Zahl NICHT dem letzten Index des Arrays entspricht, wird noch geprüft, ob die aktuelle Zahl kleiner als die nächste Zahl ist und darauf hin die Schleife von neuem begonnen
                if num == arabNum.count - 1{
                    result += currentNum
                    continue
                }
                else{
                    if currentNum < arabNum[num + 1] {
                        continue
                    }
                }
                
                
                result += currentNum
                continue
            }

        }
        //Anzeige aktualisieren
        labelResult.integerValue = result
        
    }
    
    
    func calcArabToRom() {
        //Mehrdimensionales Array für die möglichen Bestandteile einer römischen Zahl
        let romanNumbers = [    ["M", "MM", "MMM"],
                                ["C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"],
                                ["X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"],
                                ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]
                                ]
        //Zuweisung der eingegebenen arabischen Zahl
        var arabNum = inputNumber.integerValue
        //Variable für den Divisor und für das Ergebnis
        var divider = 1000
        var result = ""
        //Schleife läuft für jede Teilungsoperation (1000,100,10,1) ein mal durch
        for num in 0...3{
            //Division der arabsichen Nummer durch den Divisor (im 1. Durchlauf 1000) und Zuweisung des Ergebnisses als Ganzzahl
            let quotient = arabNum / divider
            //Subtraktion der Multiplikation von quotient und divisor von arabNum, damit die arabische Zahl einen Stellenwert (im 1. Durchlauf auf 100er) verringert wird
            arabNum -= (quotient * divider)
            //wenn Divisor 1 ist UND Quotient nicht 0, dann wird die entsprechende römische Zahl zu result addiert und in den Schleifenkopf gesprungen
            if divider == 1 && quotient != 0{
                result += romanNumbers[num][quotient - 1]
                continue
            }
            //wenn der Quotient 0 ist, dann wird der Divisor um einen Stellenwert reduziert und die Schleife von neuem begonnen
            if quotient == 0 {
                divider = divider / 10
                continue
            }
            //ansonsten wird die entsprechende römische Zahl zum Ergebnis hinzugefügt
            result += romanNumbers[num][quotient - 1]
            //und der Divisor um einen Stellenwert reduziert
            divider = divider / 10
        }
        //Zuweisung des Ergebnisses zum Label
        labelResult.stringValue = result

    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

