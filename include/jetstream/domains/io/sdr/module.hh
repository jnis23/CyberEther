#ifndef JETSTREAM_DOMAINS_IO_SDR_MODULE_HH
#define JETSTREAM_DOMAINS_IO_SDR_MODULE_HH

#include "jetstream/memory/types.hh"
#include "jetstream/module.hh"

namespace Jetstream::Modules {

struct Sdr : public Module::Config {
    std::string deviceString = "";
    std::string antenna = "";
    bool dualRx = false;
    bool automaticGain2 = true;
    F32 manualGain2 = 30.0f;
    F32 frequency = 96.9e6;
    F32 sampleRate = 2.0e6;
    bool automaticGain = true;
    F32 manualGain = 30.0f;
    bool biasTee = false;
    U64 numberOfBatches = 8;
    U64 numberOfTimeSamples = 8192;
    U64 bufferMultiplier = 4;

    JST_MODULE_TYPE(sdr);
    JST_MODULE_PARAMS(deviceString, antenna, dualRx, automaticGain2, manualGain2,
                      frequency, sampleRate, automaticGain, manualGain, biasTee,
                      numberOfBatches, numberOfTimeSamples, bufferMultiplier);
};

}  // namespace Jetstream::Modules

#endif  // JETSTREAM_DOMAINS_IO_SDR_MODULE_HH
