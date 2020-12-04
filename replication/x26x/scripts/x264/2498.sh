#!/bin/sh

numb='2499'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 0.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 4 --crf 45 --keyint 200 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 1 --qpmax 61 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.5,1.0,0.2,0.6,0.8,0.1,3,2,4,45,200,2,29,10,4,1,61,18,4,2000,1:1,umh,crop,veryfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"