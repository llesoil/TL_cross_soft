#!/bin/sh

numb='2343'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.4 --psy-rd 0.8 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 3 --b-adapt 1 --bframes 4 --crf 0 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.0,1.4,0.8,0.4,0.8,0.8,3,1,4,0,260,0,20,40,4,4,69,48,4,2000,-2:-2,umh,show,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"