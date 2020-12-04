#!/bin/sh

numb='80'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.0 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.0,1.4,1.3,3.0,0.2,0.8,0.6,0,1,16,35,230,4,30,40,3,0,65,18,2,2000,-1:-1,umh,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"