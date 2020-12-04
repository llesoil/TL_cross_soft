#!/bin/sh

numb='1457'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 3.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 15 --keyint 280 --lookahead-threads 1 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.0,1.4,1.2,3.0,0.5,0.8,0.8,3,2,10,15,280,1,27,30,4,2,65,18,6,2000,1:1,dia,crop,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"