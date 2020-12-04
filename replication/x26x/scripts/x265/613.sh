#!/bin/sh

numb='614'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 12 --crf 45 --keyint 290 --lookahead-threads 2 --min-keyint 30 --qp 50 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan crop --preset veryslow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.5,1.3,1.2,0.6,0.6,0.3,0,1,12,45,290,2,30,50,4,3,66,18,1,1000,-2:-2,dia,crop,veryslow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"