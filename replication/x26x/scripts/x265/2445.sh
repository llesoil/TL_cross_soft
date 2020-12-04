#!/bin/sh

numb='2446'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 2 --crf 20 --keyint 230 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,3.0,1.1,1.3,0.4,0.3,0.8,0.3,2,2,2,20,230,4,20,0,5,1,63,28,2,1000,-2:-2,umh,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"