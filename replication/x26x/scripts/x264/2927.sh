#!/bin/sh

numb='2928'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 0 --crf 10 --keyint 300 --lookahead-threads 2 --min-keyint 29 --qp 50 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,1.0,1.4,1.3,4.8,0.6,0.9,0.4,2,1,0,10,300,2,29,50,5,0,65,38,4,1000,1:1,umh,crop,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"