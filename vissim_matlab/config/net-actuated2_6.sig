<?xml version="1.0" encoding="UTF-8"?>
<sc id="6" name="" frequency="1" steps="0" defaultIntergreenMatrix="0">
  <sgs>
    <sg id="21" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="22" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="23" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="24" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
  </sgs>
  <intergreenmatrices />
  <progs>
    <prog id="1" cycletime="100000" switchpoint="0" offset="58000" intergreens="0" fitness="0.000000" vehicleCount="0" name="Signal program">
      <sgs>
        <sg sg_id="21" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="0" />
            <cmd display="1" begin="22000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="22" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="24000" />
            <cmd display="1" begin="57000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="23" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="59000" />
            <cmd display="1" begin="73000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="24" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="75000" />
            <cmd display="1" begin="98000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
      </sgs>
    </prog>
  </progs>
  <stages />
  <interstageProgs />
  <stageProgs />
  <dailyProgLists />
</sc>