import { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [vision, setVision] = useState("")
  const [earActive, setEarActive] = useState(false)
  const [eyePreview, setEyePreview] = useState<string | null>(null)

useEffect(() => {
  const interval = setInterval(() => {
    fetch("/tmp/bob_vision.txt")
      .then(res => res.text())
      .then(setVision)

    fetch("/tmp/bob_eye.jpg")
      .then(res => res.blob())
      .then(blob => setEyePreview(URL.createObjectURL(blob)))
      .catch(() => setEyePreview(null))
  }, 1000)
  return () => clearInterval(interval)
}, [])

  // Fetch blurred image preview
  useEffect(() => {
    const interval = setInterval(() => {
      fetch('/tmp/bob_eye.jpg')
        .then(res => res.blob())
        .then(blob => {
          setEyePreview(URL.createObjectURL(blob))
        })
        .catch(() => setEyePreview(null))
    }, 1111)
    return () => clearInterval(interval)
  }, [])

  return (
    <div className="hud">
      <h1>BOB HUD 👁👂</h1>
      
      <button onClick={() => setEyeActive(!eyeActive)}>
        👁 Eye: {eyeActive ? 'ON' : 'OFF'}
      </button>
      <button onClick={() => setEarActive(!earActive)}>
        👂 Ear: {earActive ? 'ON' : 'OFF'}
      </button>

      {eyePreview && (
        <div className="preview">
          <img src={eyePreview} alt="BOB Eye" style={{ filter: 'blur(2px)', maxWidth: '300px' }} />
          <p className="caption">(live blurred eye)</p>
        </div>
      )}
    </div>
  )
}

export default App
