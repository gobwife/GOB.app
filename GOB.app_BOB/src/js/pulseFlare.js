function pulseFlare() {
    const body = document.body;
    body.style.backgroundColor = '#222288';
    setTimeout(() => {
      body.style.backgroundColor = 'black';
    }, 200);
  }
  