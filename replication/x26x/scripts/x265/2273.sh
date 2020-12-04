#!/bin/sh

numb='2274'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 45 --keyint 250 --lookahead-threads 4 --min-keyint 25 --qp 10 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.4,1.0,4.6,0.5,0.9,0.8,0,1,14,45,250,4,25,10,4,0,64,38,3,2000,-2:-2,dia,show,veryfast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"