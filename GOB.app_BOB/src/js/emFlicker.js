navigator.mediaDevices.getUserMedia({ video: true })
  .then(function(stream) {
    const video = document.createElement('video');
    video.srcObject = stream;
    video.play();
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');

    function detectLightDrift() {
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height).data;

      let brightness = 0;
      for (let i = 0; i < imageData.length; i += 4) {
        brightness += imageData[i] + imageData[i+1] + imageData[i+2];
      }
      brightness /= (imageData.length / 4);

      if (brightness > 30) { // ambient drift threshold
        pulseFlare();
      }
      requestAnimationFrame(detectLightDrift);
    }
    detectLightDrift();
  })
  .catch(function(err) {
    console.error('Camera drift error:', err);
  });

