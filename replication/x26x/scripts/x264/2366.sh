#!/bin/sh

numb='2367'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 0.4 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 20 --keyint 210 --lookahead-threads 0 --min-keyint 26 --qp 0 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset placebo --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.1,1.0,0.4,0.6,0.7,0.0,1,0,16,20,210,0,26,0,4,0,64,18,1,2000,-2:-2,dia,show,placebo,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"