#!/bin/sh

numb='819'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 14 --crf 0 --keyint 230 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset fast --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.5,1.2,0.8,0.3,0.7,0.6,2,1,14,0,230,3,29,0,3,4,67,28,5,2000,1:1,umh,show,fast,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"