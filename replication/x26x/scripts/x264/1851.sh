#!/bin/sh

numb='1852'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 0 --crf 5 --keyint 230 --lookahead-threads 3 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.0,4.8,0.2,0.8,0.2,2,2,0,5,230,3,21,0,4,4,64,38,4,1000,1:1,dia,show,placebo,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"