#!/bin/sh

numb='2537'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 3 --b-adapt 0 --bframes 12 --crf 50 --keyint 250 --lookahead-threads 0 --min-keyint 28 --qp 20 --qpstep 3 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.2,1.4,0.4,0.2,0.6,0.3,3,0,12,50,250,0,28,20,3,0,60,38,5,2000,-1:-1,umh,crop,veryslow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"