#!/bin/sh

numb='3047'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 15 --keyint 280 --lookahead-threads 3 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,1.5,1.3,1.0,4.4,0.5,0.6,0.4,2,1,12,15,280,3,30,50,3,2,64,38,5,2000,1:1,umh,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"