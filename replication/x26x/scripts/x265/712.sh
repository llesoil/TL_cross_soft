#!/bin/sh

numb='713'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 15 --keyint 290 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset faster --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,2.5,1.5,1.4,1.4,0.5,0.9,0.4,3,2,12,15,290,2,29,40,4,4,62,38,3,2000,-2:-2,hex,show,faster,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"