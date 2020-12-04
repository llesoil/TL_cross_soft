#!/bin/sh

numb='470'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 40 --keyint 210 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 5 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.5,1.2,0.2,0.3,0.6,0.1,0,0,6,40,210,1,20,10,5,0,64,28,1,2000,-2:-2,umh,crop,superfast,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"