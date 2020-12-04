#!/bin/sh

numb='2322'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 4.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 0 --keyint 200 --lookahead-threads 2 --min-keyint 24 --qp 50 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.0,1.4,1.0,4.0,0.5,0.7,0.6,3,0,6,0,200,2,24,50,3,2,68,18,3,1000,1:1,dia,show,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"