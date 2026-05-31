/* screen_settings.jsx — App settings */

function SettingRow({ icon, label, sublabel, right, onPress, danger }) {
  return (
    <button className="tap" onClick={onPress} style={{
      width: '100%', padding: '14px 18px', textAlign: 'left',
      display: 'flex', alignItems: 'center', gap: 14,
      background: 'transparent', color: danger ? 'var(--red)' : 'var(--text-1)',
    }}>
      <div style={{
        width: 36, height: 36, borderRadius: 11, flexShrink: 0,
        background: danger ? 'var(--red-soft)' : 'var(--surface-3)',
        color: danger ? 'var(--red)' : 'var(--text-2)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        {icon}
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="disp" style={{ fontSize: 14.5, fontWeight: 600, color: danger ? 'var(--red)' : 'var(--text-1)' }}>
          {label}
        </div>
        {sublabel && (
          <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', marginTop: 2 }}>{sublabel}</div>
        )}
      </div>
      {right}
    </button>
  );
}

function ToggleSwitch({ value, onChange }) {
  return (
    <button className="tap" onClick={() => onChange(!value)} style={{
      width: 44, height: 26, borderRadius: 13, flexShrink: 0,
      background: value ? 'var(--accent)' : 'var(--surface-3)',
      position: 'relative', transition: 'background .2s',
      border: '1px solid ' + (value ? 'transparent' : 'var(--border-strong)'),
    }}>
      <div style={{
        position: 'absolute', top: 3,
        left: value ? 21 : 3,
        width: 18, height: 18, borderRadius: '50%',
        background: '#fff',
        transition: 'left .22s cubic-bezier(.22,.61,.36,1)',
        boxShadow: '0 1px 4px rgba(0,0,0,.25)',
      }} />
    </button>
  );
}

function ChevronRight() {
  return <span style={{ color: 'var(--text-3)', display: 'flex' }}><IconChevron size={18} /></span>;
}

function SettingsSection({ label, children }) {
  return (
    <div style={{ marginBottom: 22 }}>
      <div className="eyebrow" style={{ marginBottom: 8, padding: '0 4px' }}>{label}</div>
      <div className="card" style={{ padding: '4px 0', overflow: 'hidden' }}>
        {React.Children.map(children, (child, i) => (
          <React.Fragment>
            {i > 0 && <div style={{ height: 1, background: 'var(--border)', margin: '0 18px' }} />}
            {child}
          </React.Fragment>
        ))}
      </div>
    </div>
  );
}

function GoalPicker({ value, onChange }) {
  const opts = [1, 2, 3, 5];
  return (
    <div style={{ display: 'flex', gap: 6 }}>
      {opts.map(n => {
        const on = value === n;
        return (
          <button key={n} className="tap" onClick={() => onChange(n)} style={{
            width: 36, height: 30, borderRadius: 10,
            fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 13,
            background: on ? 'var(--accent)' : 'var(--surface-3)',
            color: on ? 'var(--on-accent)' : 'var(--text-2)',
            border: '1px solid ' + (on ? 'transparent' : 'var(--border)'),
          }}>{n}</button>
        );
      })}
    </div>
  );
}

function ModeToggle({ value, onChange }) {
  return (
    <div style={{
      display: 'flex', gap: 4, padding: '3px',
      background: 'var(--surface-3)', borderRadius: 12,
    }}>
      {['striver', 'custom'].map(id => {
        const on = value === id;
        return (
          <button key={id} className="tap" onClick={() => onChange(id)} style={{
            flex: 1, padding: '7px 10px', borderRadius: 9,
            fontFamily: 'var(--font-display)', fontSize: 12, fontWeight: 600,
            background: on ? 'var(--surface-2)' : 'transparent',
            color: on ? 'var(--accent)' : 'var(--text-3)',
            border: on ? '1px solid var(--border)' : '1px solid transparent',
            transition: 'all .18s ease',
            whiteSpace: 'nowrap',
          }}>
            {id === 'striver' ? 'Striver' : 'Custom'}
          </button>
        );
      })}
    </div>
  );
}

/* ── Screen root ──────────────────────────────────────────── */
function SettingsScreen({ onBack, tweaks, setTweak }) {
  const [darkMode, setDarkMode]         = React.useState(true);
  const [mode, setMode]                 = React.useState('striver');
  const [goal, setGoal]                 = React.useState(2);
  const [notifications, setNotifications] = React.useState(true);
  const [reviewReminder, setReviewReminder] = React.useState(true);

  const handleDarkMode = (v) => {
    setDarkMode(v);
    setTweak && setTweak('dark', v);
  };

  return (
    <div className="screen animate-in" style={{ paddingTop: 10 }}>

      {/* Header */}
      <div className="row" style={{ gap: 12, padding: '4px 2px 22px' }}>
        <button className="tap" onClick={onBack} style={{
          width: 38, height: 38, borderRadius: 12, flexShrink: 0,
          background: 'var(--surface-2)', border: '1px solid var(--border)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--text-2)',
        }}>
          <IconBack size={20} />
        </button>
        <div className="disp" style={{ fontSize: 24, fontWeight: 700, letterSpacing: '-.6px' }}>Settings</div>
      </div>

      {/* User card */}
      <div className="card" style={{ padding: '18px 20px', marginBottom: 22 }}>
        <div className="row" style={{ gap: 14 }}>
          <div style={{
            width: 52, height: 52, borderRadius: 18, flexShrink: 0,
            background: 'var(--accent-soft)', color: 'var(--accent)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: 20,
          }}>MK</div>
          <div style={{ flex: 1 }}>
            <div className="disp" style={{ fontSize: 17, fontWeight: 700 }}>Maya Kim</div>
            <div className="mono" style={{ fontSize: 11.5, color: 'var(--text-3)', marginTop: 3 }}>
              Beginner · {mode === 'striver' ? 'Striver Mode' : 'Custom Mode'}
            </div>
          </div>
          <button className="tap" style={{
            width: 34, height: 34, borderRadius: 10,
            background: 'var(--surface-3)', color: 'var(--text-2)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <IconEdit size={16} />
          </button>
        </div>
      </div>

      {/* Practice section */}
      <SettingsSection label="Practice">
        <SettingRow
          icon={<IconSwap size={18} />}
          label="Curriculum mode"
          sublabel={mode === 'striver' ? 'Striver A2Z — 474 problems' : 'Custom — log any problem'}
          right={<ModeToggle value={mode} onChange={setMode} />}
        />
        <SettingRow
          icon={<IconTarget size={18} />}
          label="Daily goal"
          sublabel="Problems per day"
          right={<GoalPicker value={goal} onChange={setGoal} />}
        />
      </SettingsSection>

      {/* Appearance section */}
      <SettingsSection label="Appearance">
        <SettingRow
          icon={<IconNote size={18} />}
          label="Dark mode"
          sublabel={darkMode ? 'Currently dark' : 'Currently light'}
          right={<ToggleSwitch value={darkMode} onChange={handleDarkMode} />}
        />
      </SettingsSection>

      {/* Notifications section */}
      <SettingsSection label="Notifications">
        <SettingRow
          icon={<IconBell size={18} />}
          label="Streak reminder"
          sublabel="Daily nudge at 8:00 PM"
          right={<ToggleSwitch value={notifications} onChange={setNotifications} />}
        />
        <SettingRow
          icon={<IconRepeat size={18} />}
          label="Review due alert"
          sublabel="When problems are due for SRS"
          right={<ToggleSwitch value={reviewReminder} onChange={setReviewReminder} />}
        />
      </SettingsSection>

      {/* Data section */}
      <SettingsSection label="Data">
        <SettingRow
          icon={<IconNote size={18} />}
          label="Export solve history"
          sublabel="Download as CSV"
          right={<ChevronRight />}
          onPress={() => {}}
        />
      </SettingsSection>

      {/* Danger section */}
      <SettingsSection label="Danger zone">
        <SettingRow
          icon={<IconTrash size={18} />}
          label="Reset all data"
          sublabel="Permanently deletes all logged problems"
          right={<ChevronRight />}
          danger
          onPress={() => {}}
        />
      </SettingsSection>

      {/* About */}
      <div style={{ textAlign: 'center', padding: '4px 0 20px' }}>
        <div className="mono" style={{ fontSize: 11, color: 'var(--text-3)', lineHeight: 1.8 }}>
          AlgoRhythm v1.0 · Fully offline · Always free{'\n'}
          Built with Flutter · No data leaves your device
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { SettingsScreen });
