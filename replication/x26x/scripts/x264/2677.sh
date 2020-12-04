#!/bin/sh

numb='2678'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 2.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 20 --keyint 230 --lookahead-threads 0 --min-keyint 23 --qp 30 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.0,1.1,2.6,0.6,0.6,0.2,1,1,4,20,230,0,23,30,3,0,64,28,5,2000,1:1,umh,crop,veryslow,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"