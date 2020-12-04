#!/bin/sh

numb='2115'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.6 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 50 --keyint 200 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 0 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset superfast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,0.0,1.6,1.1,3.6,0.5,0.9,0.4,0,0,16,50,200,0,21,0,5,0,66,28,4,2000,-1:-1,umh,crop,superfast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"