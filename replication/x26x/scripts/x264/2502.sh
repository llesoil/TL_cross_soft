#!/bin/sh

numb='2503'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 20 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 1 --qpmax 60 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.2,0.2,0.4,0.9,0.9,1,1,12,20,210,2,22,40,4,1,60,28,1,2000,-2:-2,dia,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"