#!/bin/sh

numb='2607'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 0.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 40 --keyint 260 --lookahead-threads 3 --min-keyint 24 --qp 20 --qpstep 3 --qpmin 1 --qpmax 66 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.2,0.6,0.2,0.9,0.2,2,0,16,40,260,3,24,20,3,1,66,38,4,2000,-2:-2,dia,show,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"