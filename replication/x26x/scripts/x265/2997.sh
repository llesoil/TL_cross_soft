#!/bin/sh

numb='2998'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 2.8 --qblur 0.5 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 25 --keyint 260 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.5,1.4,2.8,0.5,0.6,0.5,3,0,12,25,260,3,26,10,3,2,66,28,5,1000,-2:-2,umh,show,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"