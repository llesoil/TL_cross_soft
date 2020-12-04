#!/bin/sh

numb='566'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.6 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 50 --keyint 240 --lookahead-threads 4 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--no-weightb,0.5,1.4,1.1,4.2,0.3,0.8,0.6,1,0,6,50,240,4,25,0,3,0,65,18,2,2000,-2:-2,umh,crop,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"