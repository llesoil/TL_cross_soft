#!/bin/sh

numb='2304'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 50 --keyint 260 --lookahead-threads 2 --min-keyint 27 --qp 0 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset superfast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,0.5,1.2,1.2,1.8,0.3,0.7,0.6,3,2,6,50,260,2,27,0,3,2,64,38,5,1000,1:1,umh,crop,superfast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"