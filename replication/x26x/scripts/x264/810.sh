#!/bin/sh

numb='811'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --intra-refresh --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 45 --keyint 240 --lookahead-threads 2 --min-keyint 28 --qp 20 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset placebo --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.0,4.6,0.6,0.7,0.0,3,0,12,45,240,2,28,20,4,3,67,48,1,1000,-2:-2,umh,show,placebo,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"