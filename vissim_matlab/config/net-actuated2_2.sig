<?xml version="1.0" encoding="UTF-8"?>
<sc id="2" name="" frequency="1" steps="0" defaultIntergreenMatrix="0">
  <sgs>
    <sg id="5" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="6" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="7" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="8" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
  </sgs>
  <intergreenmatrices />
  <progs>
    <prog id="1" cycletime="100000" switchpoint="0" offset="45000" intergreens="0" fitness="0.000000" vehicleCount="0" name="Signal program">
      <sgs>
        <sg sg_id="5" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="0" />
            <cmd display="1" begin="23000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="6" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="25000" />
            <cmd display="1" begin="57000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="7" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="59000" />
            <cmd display="1" begin="72000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="8" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="74000" />
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