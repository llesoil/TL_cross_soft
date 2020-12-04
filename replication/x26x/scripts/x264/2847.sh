#!/bin/sh

numb='2848'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 2.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 35 --keyint 240 --lookahead-threads 4 --min-keyint 28 --qp 20 --qpstep 5 --qpmin 4 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.2,2.8,0.4,0.9,0.5,1,0,16,35,240,4,28,20,5,4,63,18,4,2000,-1:-1,umh,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"