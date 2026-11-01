/**
 * CodeQuest Web Audio FX Synthesizer
 * Pure Web Audio API (Zero external dependencies, 100% offline)
 */
(function() {
    let audioCtx = null;
    let isMuted = localStorage.getItem('cq_sound_muted') === 'true';

    function getAudioContext() {
        if (!audioCtx) {
            const AudioContext = window.AudioContext || window.webkitAudioContext;
            if (AudioContext) {
                audioCtx = new AudioContext();
            }
        }
        if (audioCtx && audioCtx.state === 'suspended') {
            audioCtx.resume();
        }
        return audioCtx;
    }

    window.CodeQuestAudio = {
        isMuted: function() {
            return isMuted;
        },

        toggleMute: function() {
            isMuted = !isMuted;
            localStorage.setItem('cq_sound_muted', isMuted);
            this.updateButtonUI();
            return isMuted;
        },

        updateButtonUI: function() {
            const btn = document.getElementById('soundToggleBtn');
            if (btn) {
                btn.innerHTML = isMuted ? '🔇 <span style="font-size:0.75rem; margin-left:4px;">Muted</span>' : '🔊 <span style="font-size:0.75rem; margin-left:4px;">FX On</span>';
                btn.title = isMuted ? 'Sound FX Muted (Click to enable)' : 'Sound FX Active (Click to mute)';
            }
        },

        playClick: function() {
            if (isMuted) return;
            try {
                const ctx = getAudioContext();
                if (!ctx) return;
                const osc = ctx.createOscillator();
                const gain = ctx.createGain();
                osc.type = 'triangle';
                osc.frequency.setValueAtTime(440, ctx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.05);
                gain.gain.setValueAtTime(0.08, ctx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.05);
                osc.connect(gain);
                gain.connect(ctx.destination);
                osc.start();
                osc.stop(ctx.currentTime + 0.05);
            } catch(e) {}
        },

        playSuccess: function() {
            if (isMuted) return;
            try {
                const ctx = getAudioContext();
                if (!ctx) return;
                const notes = [523.25, 659.25, 783.99, 1046.50]; // C5, E5, G5, C6
                notes.forEach((freq, idx) => {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = 'sine';
                    osc.frequency.setValueAtTime(freq, ctx.currentTime + idx * 0.09);
                    gain.gain.setValueAtTime(0.12, ctx.currentTime + idx * 0.09);
                    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + idx * 0.09 + 0.25);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(ctx.currentTime + idx * 0.09);
                    osc.stop(ctx.currentTime + idx * 0.09 + 0.25);
                });
            } catch(e) {}
        },

        playFail: function() {
            if (isMuted) return;
            try {
                const ctx = getAudioContext();
                if (!ctx) return;
                const notes = [300, 240];
                notes.forEach((freq, idx) => {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = 'sawtooth';
                    osc.frequency.setValueAtTime(freq, ctx.currentTime + idx * 0.15);
                    gain.gain.setValueAtTime(0.1, ctx.currentTime + idx * 0.15);
                    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + idx * 0.15 + 0.2);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(ctx.currentTime + idx * 0.15);
                    osc.stop(ctx.currentTime + idx * 0.15 + 0.2);
                });
            } catch(e) {}
        },

        playLevelUp: function() {
            if (isMuted) return;
            try {
                const ctx = getAudioContext();
                if (!ctx) return;
                const notes = [440, 554.37, 659.25, 880, 1108.73, 1318.51]; // Major triumphant arpeggio
                notes.forEach((freq, idx) => {
                    const osc = ctx.createOscillator();
                    const gain = ctx.createGain();
                    osc.type = 'triangle';
                    osc.frequency.setValueAtTime(freq, ctx.currentTime + idx * 0.1);
                    gain.gain.setValueAtTime(0.15, ctx.currentTime + idx * 0.1);
                    gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + idx * 0.1 + 0.35);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(ctx.currentTime + idx * 0.1);
                    osc.stop(ctx.currentTime + idx * 0.1 + 0.35);
                });
            } catch(e) {}
        }
    };

    document.addEventListener('DOMContentLoaded', function() {
        window.CodeQuestAudio.updateButtonUI();

        // Attach click audio to interactive elements
        document.querySelectorAll('button, .cq-nav-btn, .filter-chip, .mission-option').forEach(el => {
            el.addEventListener('click', () => window.CodeQuestAudio.playClick());
        });
    });
})();

