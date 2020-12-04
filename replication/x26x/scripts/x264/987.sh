#!/bin/sh

numb='988'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 0 --keyint 210 --lookahead-threads 2 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,1.5,1.3,1.4,0.4,0.3,0.8,0.0,0,0,16,0,210,2,25,30,3,4,60,38,4,1000,-1:-1,umh,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"