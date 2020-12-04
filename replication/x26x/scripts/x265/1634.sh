#!/bin/sh

numb='1635'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 35 --keyint 290 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.0,1.2,1.2,4.4,0.4,0.8,0.1,2,1,16,35,290,3,30,50,3,4,60,38,4,2000,-2:-2,hex,show,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"