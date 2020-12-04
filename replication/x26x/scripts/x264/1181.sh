#!/bin/sh

numb='1182'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.8 --qblur 0.2 --qcomp 0.7 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 45 --keyint 240 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.2,4.8,0.2,0.7,0.8,3,2,14,45,240,2,24,10,5,4,64,18,3,1000,-1:-1,hex,show,slower,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"