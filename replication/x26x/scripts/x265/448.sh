#!/bin/sh

numb='449'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 45 --keyint 300 --lookahead-threads 0 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 4 --qpmax 64 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.2,1.4,4.4,0.4,0.7,0.0,3,0,16,45,300,0,29,10,5,4,64,38,6,2000,-1:-1,dia,show,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"