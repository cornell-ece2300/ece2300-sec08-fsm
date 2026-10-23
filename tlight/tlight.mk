#=========================================================================
# tlight
#=========================================================================

tlight_srcs = \
  Register_2b_RTL.v \
  TimerUnit_RTL.v \
  LightUnit_RTL.v \
  TrafficLightController_RTL.v \

tlight_tests = \
  Register_2b_RTL-test.v \
  TimerUnit_RTL-test.v \
  LightUnit_RTL-test.v \
  TrafficLightController_RTL-test.v \

tlight_sims = \
  tlight-sim.v \

$(eval $(call check_part,tlight))
