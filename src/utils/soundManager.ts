
class SoundManager {
  private initialized: boolean = false;
  private sounds: Record<string, HTMLAudioElement> = {};
  
  initialize() {
    if (this.initialized) return;
    
    try {
      // Pre-load sounds
      this.sounds['yo'] = new Audio('/sounds/yo-sound.mp3');
      this.sounds['share'] = new Audio('/sounds/yo-sound.mp3'); // Reusing the yo sound for sharing
      this.sounds['notification'] = new Audio('/sounds/yo-sound.mp3'); // Reusing for notifications
      
      this.initialized = true;
    } catch (error) {
      console.error('Failed to initialize sound manager:', error);
    }
  }
  
  play(soundName: string, volume = 1.0) {
    try {
      if (!this.initialized) this.initialize();
      
      const sound = this.sounds[soundName];
      if (sound) {
        sound.volume = volume;
        sound.currentTime = 0;
        sound.play().catch(error => {
          console.error(`Failed to play sound ${soundName}:`, error);
        });
      } else {
        console.warn(`Sound ${soundName} not found`);
      }
    } catch (error) {
      console.error(`Error playing sound ${soundName}:`, error);
    }
  }
  
  stop(soundName: string) {
    try {
      const sound = this.sounds[soundName];
      if (sound) {
        sound.pause();
        sound.currentTime = 0;
      }
    } catch (error) {
      console.error(`Error stopping sound ${soundName}:`, error);
    }
  }
}

// Export singleton instance
export default new SoundManager();
