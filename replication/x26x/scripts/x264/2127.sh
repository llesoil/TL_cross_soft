#!/bin/sh

numb='2128'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.4 --psy-rd 1.0 --qblur 0.6 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 4 --crf 5 --keyint 200 --lookahead-threads 2 --min-keyint 20 --qp 30 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset placebo --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.4,1.0,0.6,0.6,0.4,0,0,4,5,200,2,20,30,4,3,63,28,3,2000,-1:-1,dia,show,placebo,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"