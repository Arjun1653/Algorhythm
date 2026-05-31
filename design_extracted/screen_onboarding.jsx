/* screen_onboarding.jsx — 3-step onboarding flow */

function StepDots({ total, current }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'center', gap: 8 }}>
      {Array.from({ length: total }).map((_, i) => (
        <div key={i} style={{
          width: i === current ? 22 : 8, height: 8, borderRadius: 4,
          background: i === current ? 'var(--accent)' : 'var(--surface-3)',
          transition: 'width .3s cubic-bezier(.22,.61,.36,1), background .2s',
        }} />
      ))}
    </div>
  );
}

function ModeCard({ id, title, subtitle, icon, features, selected, onSelect }) {
  const on = selected === id;
  return (
    <button className="tap" onClick={() => onSelect(id)} style={{
      width: '100%', padding: '18px 20px', borderRadius: 20, textAlign: 'left',
      background: on ? 'var(--accent-soft)' : 'var(--surface-2)',
      border: '1.5px solid ' + (on ? 'var(--accent-line)' : 'var(--border)'),
      color: 'var(--text-1)', marginBottom: 12,
    }}>
      <div className="row" style={{ gap: 14, marginBottom: 14 }}>
        <div style={{
          width: 44, height: 44, borderRadius: 14, flexShrink: 0,
          background: on ? 'var(--accent)' : 'var(--surface-3)',
          color: on ? 'var(--on-accent)' : 'var(--text-2)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{icon}</div>
        <div style={{ flex: 1 }}>
          <div className="disp" style={{ fontSize: 16, fontWeight: 700 }}>{title}</div>
          <div className="mono" style={{ fontSize: 11, color: 'var(--text-2)', marginTop: 2 }}>{subtitle}</div>
        </div>
        <div style={{
          width: 22, height: 22, borderRadius: '50%', flexShrink: 0,
          border: '2px solid ' + (on ? 'var(--accent)' : 'var(--border-strong)'),
          background: on ? 'var(--accent)' : 'transparent',
          display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--on-accent)',
        }}>
          {on && <IconCheck size={13} sw={2.5} />}
        </div>
      </div>
      {features.map((f, i) => (
        <div key={i} className="row" style={{ gap: 8, marginTop: 7 }}>
          <span style={{ color: on ? 'var(--accent)' : 'var(--text-3)', display: 'flex', flexShrink: 0 }}>
            <IconCheck size={14} sw={2.5} />
          </span>
          <span className="mono" style={{ fontSize: 11.5, color: 'var(--text-2)' }}>{f}</span>
        </div>
      ))}
    </button>
  );
}

function LevelCard({ id, emoji, label, desc, selected, onSelect }) {
  const on = selected === id;
  return (
    <button className="tap" onClick={() => onSelect(id)} style={{
      flex: 1, padding: '18px 10px', borderRadius: 18, textAlign: 'center',
      background: on ? 'var(--accent-soft)' : 'var(--surface-2)',
      border: '1.5px solid ' + (on ? 'var(--accent-line)' : 'var(--border)'),
      color: 'var(--text-1)',
    }}>
      <div style={{ fontSize: 26, marginBottom: 8 }}>{emoji}</div>
      <div className="disp" style={{ fontSize: 13, fontWeight: 700, color: on ? 'var(--accent)' : 'var(--text-1)' }}>
        {label}
      </div>
      <div className="mono" style={{ fontSize: 10, color: 'var(--text-3)', marginTop: 5, lineHeight: 1.5 }}>
        {desc}
      </div>
    </button>
  );
}

function GoalCard({ n, label, selected, onSelect }) {
  const on = selected === n;
  return (
    <button className="tap" onClick={() => onSelect(n)} style={{
      flex: 1, padding: '16px 8px', borderRadius: 18, textAlign: 'center',
      background: on ? 'var(--accent)' : 'var(--surface-2)',
      border: '1.5px solid ' + (on ? 'transparent' : 'var(--border)'),
      color: on ? 'var(--on-accent)' : 'var(--text-2)',
    }}>
      <div className="disp" style={{ fontSize: 30, fontWeight: 700, letterSpacing: '-.5px' }}>{n}</div>
      <div className="mono" style={{ fontSize: 10, marginTop: 5, opacity: 0.8 }}>{label}</div>
    </button>
  );
}

/* ── Step bodies ──────────────────────────────────────────── */
function StepMode({ mode, setMode }) {
  return (
    <div>
      <div className="eyebrow" style={{ color: 'var(--accent)' }}>Step 1 of 3</div>
      <div className="disp" style={{ fontSize: 26, fontWeight: 700, letterSpacing: '-.7px', margin: '8px 0 6px' }}>
        Choose your path
      </div>
      <div style={{ fontSize: 13.5, color: 'var(--text-2)', marginBottom: 24, lineHeight: 1.6 }}>
        Both modes use the same SRS engine. You can switch anytime from Settings.
      </div>
      <ModeCard
        id="striver"
        title="Striver Mode"
        subtitle="Recommended for beginners"
        icon={<IconLayers size={22} />}
        features={['474 problems pre-loaded (A2Z sheet)', 'Battle-tested linear sequence', 'No decision fatigue — just follow the path']}
        selected={mode}
        onSelect={setMode}
      />
      <ModeCard
        id="custom"
        title="Custom Mode"
        subtitle="For self-directed learners"
        icon={<IconTarget size={22} />}
        features={['Search from 900+ problems across 8 sources', 'Build your own roadmap at your own pace', 'Mix LeetCode, Codeforces, GFG and more']}
        selected={mode}
        onSelect={setMode}
      />
    </div>
  );
}

function StepLevel({ level, setLevel }) {
  return (
    <div>
      <div className="eyebrow" style={{ color: 'var(--accent)' }}>Step 2 of 3</div>
      <div className="disp" style={{ fontSize: 26, fontWeight: 700, letterSpacing: '-.7px', margin: '8px 0 6px' }}>
        Your current level
      </div>
      <div style={{ fontSize: 13.5, color: 'var(--text-2)', marginBottom: 24, lineHeight: 1.6 }}>
        Calibrates your daily challenge difficulty and weak area detection.
      </div>
      <div style={{ display: 'flex', gap: 10 }}>
        <LevelCard id="beginner"     emoji="🌱" label="Beginner"    desc={'New to DSA\nor CS basics'}          selected={level} onSelect={setLevel} />
        <LevelCard id="intermediate" emoji="⚡" label="Mid-level"   desc={'Solved 50+\nproblems before'}       selected={level} onSelect={setLevel} />
        <LevelCard id="rusty"        emoji="🔧" label="Rusty"       desc={'Know the basics,\nneed revision'}   selected={level} onSelect={setLevel} />
      </div>
      <div style={{
        marginTop: 18, padding: '14px 16px', borderRadius: 14,
        background: 'var(--surface-2)', border: '1px solid var(--border)',
      }}>
        <div className="mono" style={{ fontSize: 12, color: 'var(--text-2)', lineHeight: 1.6 }}>
          {level === 'beginner'     && '🌱 We\'ll start you from easy problems and gradually unlock harder ones as your mastery grows.'}
          {level === 'intermediate' && '⚡ We\'ll skip trivials and surface medium/hard problems earlier. Focus areas based on gaps.'}
          {level === 'rusty'        && '🔧 We\'ll prioritize topics you haven\'t touched recently using recency-weighted mastery scores.'}
        </div>
      </div>
    </div>
  );
}

function StepGoal({ goal, setGoal, mode }) {
  const totalProblems = mode === 'striver' ? 474 : 150;
  const listName      = mode === 'striver' ? 'Striver A2Z' : 'NeetCode 150';
  const days          = Math.ceil(totalProblems / goal);
  return (
    <div>
      <div className="eyebrow" style={{ color: 'var(--accent)' }}>Step 3 of 3</div>
      <div className="disp" style={{ fontSize: 26, fontWeight: 700, letterSpacing: '-.7px', margin: '8px 0 6px' }}>
        Daily target
      </div>
      <div style={{ fontSize: 13.5, color: 'var(--text-2)', marginBottom: 24, lineHeight: 1.6 }}>
        Be realistic — a streak of 1 problem/day beats a burnout sprint every time.
      </div>
      <div style={{ display: 'flex', gap: 10, marginBottom: 18 }}>
        <GoalCard n={1} label="Light"   selected={goal} onSelect={setGoal} />
        <GoalCard n={2} label="Steady"  selected={goal} onSelect={setGoal} />
        <GoalCard n={3} label="Focused" selected={goal} onSelect={setGoal} />
        <GoalCard n={5} label="Grind"   selected={goal} onSelect={setGoal} />
      </div>
      <div style={{
        padding: '16px 18px', borderRadius: 16,
        background: 'var(--emerald-soft)',
        border: '1px solid color-mix(in oklch, var(--emerald) 24%, transparent)',
      }}>
        <div className="row" style={{ gap: 10 }}>
          <span style={{ color: 'var(--emerald)', display: 'flex' }}><IconTarget size={20} /></span>
          <div className="mono" style={{ fontSize: 12, color: 'var(--emerald)', lineHeight: 1.6 }}>
            At <strong>{goal} problem{goal > 1 ? 's' : ''}/day</strong> you'll finish {listName} in ~<strong>{days} days</strong>.
            {days <= 90 && ' That\'s less than 3 months. Totally doable.'}
            {days > 90 && days <= 180 && ' Steady pace — keep your streak alive.'}
            {days > 180 && ' Slow and steady. Any daily progress beats zero.'}
          </div>
        </div>
      </div>
    </div>
  );
}

/* ── Root component ───────────────────────────────────────── */
function OnboardingScreen({ onDone }) {
  const [step, setStep]   = React.useState(0);
  const [mode, setMode]   = React.useState('striver');
  const [level, setLevel] = React.useState('beginner');
  const [goal, setGoal]   = React.useState(2);

  const stepBodies = [
    <StepMode  mode={mode}   setMode={setMode} />,
    <StepLevel level={level} setLevel={setLevel} />,
    <StepGoal  goal={goal}   setGoal={setGoal} mode={mode} />,
  ];

  const handleNext = () => {
    if (step < stepBodies.length - 1) setStep(s => s + 1);
    else onDone && onDone({ mode, level, goal });
  };
  const handleBack = () => setStep(s => s - 1);

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100%', overflow: 'hidden' }}>

      {/* App brand header (step 0 only) */}
      {step === 0 && (
        <div style={{ padding: '28px 24px 20px', flexShrink: 0 }}>
          <div className="row" style={{ gap: 12 }}>
            <div style={{
              width: 44, height: 44, borderRadius: 14,
              background: 'var(--accent)', color: 'var(--on-accent)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <IconFlameSolid size={26} />
            </div>
            <div>
              <div className="disp" style={{ fontSize: 20, fontWeight: 700, letterSpacing: '-.4px' }}>AlgoRhythm</div>
              <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)' }}>Your personal DSA coach</div>
            </div>
          </div>
        </div>
      )}

      {/* Back header (steps 1+) */}
      {step > 0 && (
        <div style={{ padding: '20px 24px 0', flexShrink: 0 }}>
          <button className="tap" onClick={handleBack} style={{
            display: 'flex', alignItems: 'center', gap: 6,
            color: 'var(--text-2)', fontFamily: 'var(--font-display)', fontSize: 14, fontWeight: 600,
          }}>
            <IconBack size={20} /> Back
          </button>
        </div>
      )}

      {/* Step content */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '20px 24px 0' }} className="heatscroll">
        <div className="animate-in" key={step}>
          {stepBodies[step]}
        </div>
      </div>

      {/* Footer */}
      <div style={{ padding: '16px 24px 44px', flexShrink: 0 }}>
        <StepDots total={3} current={step} />
        <button className="tap" onClick={handleNext} style={{
          width: '100%', height: 54, borderRadius: 17, marginTop: 20,
          background: 'var(--accent)', color: 'var(--on-accent)',
          fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 16,
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
        }}>
          {step < 2 ? 'Continue' : 'Start practicing'}
          <IconArrowRight size={20} />
        </button>
        {step === 0 && (
          <div className="mono" style={{ textAlign: 'center', fontSize: 11, color: 'var(--text-3)', marginTop: 14 }}>
            No account needed · fully offline · always free
          </div>
        )}
      </div>
    </div>
  );
}

Object.assign(window, { OnboardingScreen });
