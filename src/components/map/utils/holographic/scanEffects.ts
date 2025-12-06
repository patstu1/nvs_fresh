
/**
 * Creates animated scan lines for futuristic effect
 */
export const addScanLines = (): void => {
  if (!document.getElementById('holo-scan-effects')) {
    const style = document.createElement('style');
    style.id = 'holo-scan-effects';
    style.innerHTML = `
      @keyframes horizontalScan {
        0% { transform: translateY(-100%); }
        100% { transform: translateY(100%); }
      }
      
      @keyframes glitchEffect {
        0% { opacity: 0.3; }
        5% { opacity: 0.5; }
        10% { opacity: 0.3; }
        15% { opacity: 0.5; }
        20% { opacity: 0.3; }
        100% { opacity: 0.3; }
      }
      
      @keyframes digitalNoise {
        0%, 100% { background-position: 0 0; }
        10% { background-position: -5% -10%; }
        30% { background-position: 3% 15%; }
        50% { background-position: -10% 5%; }
        70% { background-position: 15% -5%; }
        90% { background-position: 5% 8%; }
      }
      
      @keyframes flickerGlow {
        0%, 100% { opacity: 0.7; }
        50% { opacity: 1; }
        60% { opacity: 0.5; }
        70% { opacity: 0.8; }
        80% { opacity: 0.6; }
        90% { opacity: 1; }
      }
      
      .hologram-container::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: repeating-linear-gradient(
          transparent 0px,
          rgba(0, 255, 196, 0.03) 1px,
          transparent 2px
        );
        pointer-events: none;
        z-index: 2;
        animation: glitchEffect 8s infinite;
      }
      
      .hologram-scan-line {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        background: linear-gradient(90deg, 
          transparent, 
          rgba(0, 255, 196, 0.2),
          rgba(0, 255, 196, 0.8),
          rgba(0, 255, 196, 0.2),
          transparent
        );
        z-index: 3;
        pointer-events: none;
        animation: horizontalScan 8s infinite linear;
        box-shadow: 0 0 15px rgba(0, 255, 196, 0.5);
      }
      
      .hologram-flicker {
        position: absolute;
        top: 25%;
        left: 0;
        right: 0;
        height: 2px;
        background: linear-gradient(90deg, 
          transparent, 
          rgba(255, 115, 0, 0.1),
          rgba(255, 115, 0, 0.9),
          rgba(255, 115, 0, 0.1),
          transparent
        );
        z-index: 3;
        pointer-events: none;
        animation: horizontalScan 5s infinite linear;
        box-shadow: 0 0 10px rgba(255, 115, 0, 0.7);
      }
      
      .cyberpunk-noise {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3CfeColorMatrix type='matrix' values='1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0.5 0'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.05'/%3E%3C/svg%3E");
        background-size: 200px;
        opacity: 0.15;
        mix-blend-mode: screen;
        pointer-events: none;
        z-index: 2;
        animation: digitalNoise 2s steps(2) infinite;
      }
      
      .neon-edges {
        position: absolute;
        inset: 0;
        border: 1px solid rgba(0, 255, 196, 0.5);
        box-shadow: 0 0 10px rgba(0, 255, 196, 0.5), 
                    inset 0 0 10px rgba(0, 255, 196, 0.3);
        pointer-events: none;
        z-index: 2;
        animation: flickerGlow 8s infinite;
      }
    `;
    
    document.head.appendChild(style);
  }
}

