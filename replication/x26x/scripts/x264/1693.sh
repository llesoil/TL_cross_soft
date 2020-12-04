#!/bin/sh

numb='1694'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.0 --psy-rd 0.8 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 40 --keyint 280 --lookahead-threads 2 --min-keyint 22 --qp 40 --qpstep 5 --qpmin 2 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.2,1.0,0.8,0.5,0.8,0.6,3,0,0,40,280,2,22,40,5,2,65,48,4,2000,-1:-1,umh,show,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"