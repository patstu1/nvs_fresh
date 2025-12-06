
declare interface SoundManager {
  initialize(): void;
  play(soundKey: string, volume?: number): void;
  stop(soundKey: string): void;
  stopAll(): void;
  setVolume(volume: number): void;
  hasSound(soundKey: string): boolean;
  addSound(soundKey: string, soundPath: string): void;
}
