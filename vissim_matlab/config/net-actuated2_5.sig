<?xml version="1.0" encoding="UTF-8"?>
<sc id="5" name="" frequency="1" steps="0" defaultIntergreenMatrix="0">
  <sgs>
    <sg id="17" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="18" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="19" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
    <sg id="20" name="" defaultSignalSequence="7">
      <defaultDurations>
        <defaultDuration display="4" duration="3000" />
        <defaultDuration display="1" duration="0" />
        <defaultDuration display="3" duration="0" />
      </defaultDurations>
    </sg>
  </sgs>
  <intergreenmatrices />
  <progs>
    <prog id="1" cycletime="100000" switchpoint="0" offset="4000" intergreens="0" fitness="0.000000" vehicleCount="0" name="Signal program">
      <sgs>
        <sg sg_id="17" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="0" />
            <cmd display="1" begin="22000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="18" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="24000" />
            <cmd display="1" begin="55000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="19" signal_sequence="7">
          <cmds>
            <cmd display="3" begin="57000" />
            <cmd display="1" begin="73000" />
          </cmds>
          <fixedstates>
            <fixedstate display="4" duration="3000" />
          </fixedstates>
        </sg>
        <sg sg_id="20" signal_sequence="7">
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