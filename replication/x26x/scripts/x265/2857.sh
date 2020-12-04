#!/bin/sh

numb='2858'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 0 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,3.0,1.6,1.2,1.6,0.5,0.8,0.1,1,1,12,0,260,0,20,30,3,4,61,28,5,2000,1:1,umh,show,ultrafast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"