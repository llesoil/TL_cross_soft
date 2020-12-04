#!/bin/sh

numb='2380'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 5.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 30 --keyint 210 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.3,5.0,0.3,0.8,0.1,0,0,12,30,210,1,23,20,4,4,69,18,1,2000,-1:-1,hex,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"