//
//  CancionesViewController.swift
//  iCanciones
//
//  Created by AlexGarcia on 10/3/16.
//  Copyright © 2016 AlexGarcia. All rights reserved.
//

import UIKit
import AVFoundation

class CancionesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private var reproductor : AVAudioPlayer!
    var cancionURL : URL? = nil
    
    @IBOutlet weak var pickerCanciones: UIPickerView!
    @IBOutlet weak var cancionLabel: UILabel!
    @IBOutlet weak var cancionPortada: UIImageView!
    @IBOutlet weak var volumen: UISlider!
    
    let canciones = ["Canta corazón",
                     "Cuando estamos juntos",
                     "Cuidado con el Corazon",
                     "Manda una señal",
                     "Ojala pudiera borrarte",
                     "Volverte amar"]
    let cancionesFile = ["cantaCorazon",
                     "cuandoEstamosJuntos",
                     "cuidadoConElCorazon",
                     "mandaUnaSenal",
                     "ojalaPudieraBorrarte",
                     "volverteAmar"]
    var images:[UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        images = [
            UIImage(named: "cantaCorazon")!,
            UIImage(named: "cuandoEstamosJuntos")!,
            UIImage(named: "cuidadoConElCorazon")!,
            UIImage(named: "mandaUnaSenal")!,
            UIImage(named: "ojalaPudieraBorrarte")!,
            UIImage(named: "volverteAmar")!
        ]
        arc4random_stir()
    }
    
    // MARK: Picker data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
    return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return canciones.count
    }

    // MARK: Picker Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return canciones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        print("\(row): \(canciones[row])")
        if reproductor != nil, reproductor.isPlaying {
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
        
        cancionURL = Bundle.main.url(forResource: cancionesFile[row], withExtension: "mp3")
        do {
            try reproductor = AVAudioPlayer(contentsOf: cancionURL!)
            reproductor.volume = volumen.value
            cancionPortada.image = images[row]
            reproductor.play()
        }
        catch {
            print("Error al cargar el archivo de sonido")
        }
    }
    
    // MARK: Actions
    @IBAction func play() {
        if cancionURL == nil {
            cancionURL = Bundle.main.url(forResource: cancionesFile[pickerCanciones.selectedRow(inComponent: 0)], withExtension: "mp3")
            do {
                try reproductor = AVAudioPlayer(contentsOf: cancionURL!)
                
            }
            catch {
                print("Error al cargar el archivo de sonido")
            }

        }
        
        if !reproductor.isPlaying  {
            reproductor.volume = volumen.value
            cancionPortada.image = images[pickerCanciones.selectedRow(inComponent: 0)]

            reproductor.play()
        }
    }
    
    @IBAction func pause() {
        if reproductor.isPlaying {
            reproductor.pause()
        }
    }

    @IBAction func stop() {
        if reproductor.isPlaying {
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
    }
    
    @IBAction func volumenChange(_ sender: UISlider) {
        reproductor.volume = sender.value
    }
    
    @IBAction func shuffle() {
        if reproductor != nil, reproductor.isPlaying {
            reproductor.stop()
            reproductor.currentTime = 0.0
        }
        let row = Int(arc4random_uniform(UInt32(canciones.count)))
        pickerCanciones.selectRow(row, inComponent: 0, animated: true)
        cancionURL = Bundle.main.url(forResource: cancionesFile[row], withExtension: "mp3")
        do {
            try reproductor = AVAudioPlayer(contentsOf: cancionURL!)
            reproductor.volume = volumen.value
            cancionPortada.image = images[row]
            reproductor.play()
        }
        catch {
            print("Error al cargar el archivo de sonido")
        }
 
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
